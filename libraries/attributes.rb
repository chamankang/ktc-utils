# Encoding: UTF-8
# rubocop:disable AccessorMethodName
module KTC
  # Yay this stuff :|
  class Attributes
    class << self
      attr_accessor :node

      # query etcd and set all known endpoints on this node
      # rubocop:disable MethodLength
      def set
        services = get_services
        Chef::Log.info "services defined: #{services.map { |m| m.name }}"
        # get a list of the known services stored in etcd & iterate
        services.each do |service|
          Chef::Log.debug "#### setting attributes for service #{service.name}"
          case service.name
          when 'memcached'
            set_memcached service
          when 'mysql'
            set_database service
          when 'rabbitmq'
            set_rabbit service
          else
            set_endpoint service
          end
        end
      end

      def get_endpoint(service, ha_d)
        ip = ha_d ? service.members.first.ip : service.endpoint.ip
        port = ha_d ? service.members.first.port : service.endpoint.port
        [ip, port]
      end

      private

      # @return an array of service objects fomr the etcd server
      def get_services
        Services::Connection.new run_context: node.run_context
        Services.all
      end

      # set stackforge attributes for mysql
      def set_database(service)
        ha_d = node['ha_disabled']
        ip, port = get_endpoint service, ha_d
        Chef::Log.info "setting database host attrs to #{ip}:#{port}"

        node.default['service_names'].each do |s|
          node.default['openstack']['db'][s]['host'] = ip
          node.default['openstack']['db'][s]['port'] = port
        end
      end

      def set_rabbit(service)
        ha_d = node['ha_disabled']
        ip, port = get_endpoint service, ha_d
        Chef::Log.info "setting rabbit host attrs to #{ip}:#{port}"

        node.default['service_names'].each do |s|
          node.default['openstack'][s]['rabbit']['host'] = ip
          node.default['openstack'][s]['rabbit']['port'] = port
          node.default['openstack'][s]['rabbit']['ha'] = false
        end
      end

      # set stackforge attributes for memcached
      def set_memcached(service)
        ips = service.members.map { |m| "#{m.ip}:#{m.port}" }
        Chef::Log.info "setting memcached attrs to #{ips}"
        node.default['openstack']['memcached_servers'] = ips
      end

      # set stackforge attributes for openstack service endpoints
      def set_endpoint(service)
        ha_d = node['ha_disabled']
        # image endpoints never run ha
        ha_d = true if %w(image-api image-registry).include?(service.name)
        ip, port = get_endpoint service, ha_d
        Chef::Log.info "setting #{service.name} host attrs to #{ip}:#{port}"

        node.default['openstack']['endpoints'][service.name]['host'] = ip
        node.default['openstack']['endpoints'][service.name]['port'] = port
      end
    end
  end
end

module KTC
  class Attributes
    class << self

      attr_accessor :node

      # query etcd and set all known endpoints on this node
      def set
        services = get_services
        Chef::Log.info "services defined: #{services.map { |m| m.name }}"
        # get a list of the known services stored in etcd & iterate
        services.each do |service|
          case service.name
          when "memcached"
            set_memcached service
          when "mysql"
            set_database service
          when "rabbitmq"
            set_rabbit service
          else
            set_endpoint service
          end
        end
      end

      private

      # @return an array of service objects fomr the etcd server
      def get_services
        Services::Connection.new run_context: node.run_context
        services = []
        Services.get('/services/').each do |service|
          name = File.basename service.key
          services << Services::Service.new(name)
        end
        services
      end

      # set stackforge attributes for mysql
      def set_database service
        ha_d = node.ha_disabled
        ip = ha_d ? service.members.first.ip : service.endpoint.ip
        port = ha_d ? service.members.first.port : service.endpoint.port
        Chef::Log.info "setting database host attrs to #{ip}:#{port}"

        node.default["service_names"].each do |s|
          node.default["openstack"]["db"][s]["host"] = ip
          node.default["openstack"]["db"][s]["port"] = port
        end
      end

      def set_rabbit service
        if node.has_disabled
          set_rabbit_single service.members.first.ip service.members.first.port
        else
          set_rabbit_ha service
        end
      end

      def set_rabbit_ha service
        ips = service.members.map { |m| m.ip }
        node.default["openstack"]["mq"]["servers"] = ips
        Chef::Log.info "setting rabbitmq cluster attrs to #{ips}"

        node.default["service_names"].map do |s|
          node.default["openstack"][s]["rabbit"]["ha"] = true
        end
      end

      def set_rabbit_single ip, port
        node.default["service_names"].each do |s|
          node.default["openstack"][s]["rabbit"]["host"] = ip
          node.default["openstack"][s]["rabbit"]["port"] = port
        end
      end

      # set stackforge attributes for memcached
      def set_memcached service
        ips = service.members.map { |m| "#{m.ip}:#{m.port}" }
        Chef::Log.info "setting memcached attrs to #{ips}"
        node.default['openstack']['memcached_servers'] = ips
      end

      # set stackforge attributes for openstack service endpoints
      def set_endpoint service
        ha_d = node[:ha_disabled]
        ip = ha_d ? service.members.first.ip : service.endpoint.ip
        port = ha_d ? service.members.first.port : service.endpoint.port
        Chef::Log.info "setting #{service.name} host attrs to #{ip}:#{port}"

        node.default["openstack"]["endpoints"][service.name]["host"] = ip
        node.default["openstack"]["endpoints"][service.name]["port"] = port
      end

    end
  end
end

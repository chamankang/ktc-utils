module KTC
  class Network
    class << self

      attr_accessor :node

      # get the interface associated with a interface name
      # @param String interface name
      # @return String eth name or nil
      def if_lookup name
        if list_interface_names.include?(name)
          return node["interface_mapping"][name]
        end
        nil
      end

      # get the ip associated with an interface name
      # @param String interface name: private/management or ethX
      # @return String ip address
      def address name
        ip = nil
        iface = if_lookup name || name
        ip =  if_addr iface
      end

      # return last octet of the given ipaddr
      def last_octet ipaddr
        ipaddr.split(".")[3].to_i
      end

      def add_service_nat service_name, port
        #node.run_context.include_recipe "simple_iptables::default"
        ep = Services::Endpoint.new service_name
        ep.load

        Chef::Log.info "Loaded endpoint #{ep.inspect}"

        if ep.ip.empty?
          short = "Endpoint #{service_name} missing IP attribute, moving on"
          Chef::Log.info short
          raise
        end

        #bash "nat_something" do
        short1 = "/sbin/iptables -t nat "
        short2 = "-D PREROUTING -p tcp -d #{ep.ip} --dport #{port} -j REDIRECT"
        short3 = "-A PREROUTING -p tcp -d #{ep.ip} --dport #{port} -j REDIRECT"

        system(short1 + short2)
        system(short1 + short3)

        # redirect VIP address to local realserver (DIRECT ROUTE)
        #simple_iptables_rule "#{service_name}-direct-route" do
        #  table "nat"
        #  direction "PREROUTING"
        #  rule "-p tcp -d #{ep.ip} --dport #{port} -j REDIRECT"
        #  jump false
        #end
      end

      private

      def if_addr int
        interface_node = node["network"]["interfaces"][int]["addresses"]
        interface_node.select do |address, data|
          if data['family'] == "inet"
            return address
          end
        end
      end

      # list all the defined interace names
      # @return Array of names
      def list_interface_names
        return node["interface_mapping"].keys
      end

      # list interfaces on this vm
      # @return Array of eth names
      def list_interfaces
        return node["network"]["interfaces"].keys
      end

    end
  end
end

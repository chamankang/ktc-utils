# encoding: UTF-8
module KTC
  # Network related helpers
  class Network
    class << self
      attr_accessor :node

      # get the interface associated with a interface name
      # @param String interface name
      # @return String eth name or nil
      def if_lookup(name)
        if list_interface_names.include?(name)
          return node['interface_mapping'][name]
        end
        nil
      end

      # get the ip associated with an interface name
      # @param String interface name: private/management or ethX
      # @return String ip address
      def address(name)
        iface = (if_lookup name) || name
        if_addr iface
      end

      # return last octet of the given ipaddr
      def last_octet(ipaddr)
        ipaddr.split('.')[3].to_i
      end

      private

      def if_addr(int)
        if node['network']['interfaces'].key? int
          interface_node = node['network']['interfaces'][int]['addresses']
        else
          Chef::Log.warn "I was asked to fetch IPaddr for unknown int #{int}"
          return nil
        end

        interface_node.select do |address, data|
          return address if data['family'] == 'inet'
        end
      end

      # list all the defined interace names
      # @return Array of names
      def list_interface_names
        # use fetch to handle the lookup, and return
        mappings = node.fetch 'interface_mapping', []
        # return list of keys or empty array
        names = mappings.to_a.empty? ? mappings : mappings.keys
        names
      end

      # list interfaces on this vm
      # @return Array of eth names
      def list_interfaces
        node['network']['interfaces'].keys
      end
    end
  end
end

# utilities for dealing with multiple interfaces

module ::KTCUtils

  # list all the defined interace names
  # @return Array of names
  def list_interface_names
    return node.default["interface_mapping"].keys
  end

  # list interfaces on this vm
  # @return Array of eth names
  def list_interfaces
    return node.automatic["network"]["interfaces"].keys
  end

  # get the interface associated with a interface name
  # @param String interface name
  # @return String eth name
  def get_interface name
    if list_interface_names.include?(name)
      return node.default["interface_mapping"][name]
    end
  end

  # get the ip associated with an interface name
  # @param String interface name
  # @return String ip address
  def get_interface_address name
    iface = get_interface name
    if list_interfaces.include?(iface)
      node.automatic["network"]["interfaces"][iface]["addresses"].each do |k,v|
        if v["family"].eql?("inet")
          return k
        end
      end
    end
  end

end

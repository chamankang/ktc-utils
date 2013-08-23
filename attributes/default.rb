
case node.chef_environment
when "dev"
  default["interface_mapping"]["management"] = "eth1"
  default["interface_mapping"]["disk"] = "eth2"
  default["interface_mapping"]["private"] = "eth3"
  default["interface_mapping"]["public"] = "eth4"
when "mkd_stag"
  if node.run_list.include?("recipe[ktc-compute]")
    default["interface_mapping"]["service"] = "eth0"
    default["interface_mapping"]["management"] = "eth1"
    default["interface_mapping"]["storage"] = "eth2"
  else
    default["interface_mapping"]["management"] = "eth0"
  end
end


case node.chef_environment
when "dev"
  default["interface_mapping"]["management"] = "eth1"
  default["interface_mapping"]["disk"] = "eth2"
  default["interface_mapping"]["private"] = "eth3"
  default["interface_mapping"]["public"] = "eth4"
when "mkd_stag"
  default["interface_mapping"]["management"] = "eth0"
end

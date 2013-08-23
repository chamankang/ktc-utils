return unless chef_environment == "mkd_stag"

if node.run_list.include?("recipe[ktc-compute]")
  default["interface_mapping"]["private"] = "eth0"
  default["interface_mapping"]["management"] = "eth1"
  default["interface_mapping"]["storage"] = "eth2"
else
  default["interface_mapping"]["management"] = "eth0"
end

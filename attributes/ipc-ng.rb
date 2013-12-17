return unless chef_environment == "ipc-ng"

include_attribute "ktc-utils::default"

if node.run_list.include?("recipe[ktc-compute::compute]")
  default["interface_mapping"]["private"] = "eth0"
  default["interface_mapping"]["management"] = "eth1"
  default["interface_mapping"]["storage"] = "eth2"
end

if node.run_list.include?("recipe[ktc-image]")
  default["interface_mapping"]["management"] = "bond0"
  default["interface_mapping"]["storage"] = "bond1"
end


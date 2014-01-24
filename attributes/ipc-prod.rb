return unless chef_environment == "ipc-prod"

include_attribute "ktc-utils::default"

if node.run_list.include?("recipe[ktc-compute::compute]")
  default["interface_mapping"]["private"] = "bond1"
  default["interface_mapping"]["management"] = "eth0"
  default["interface_mapping"]["storage"] = "bond2"
end

if node.run_list.include?("recipe[ktc-image]")
  default["interface_mapping"]["management"] = "bond0"
  default["interface_mapping"]["storage"] = "bond1"
end

if node.hostname.include?("znode")
  default["interface_mapping"]["management"] = "br0"
  default["interface_mapping"]["storage"] = "br1"
end
if node.hostname.include?("mnode")
  default["interface_mapping"]["management"] = "br0"
end

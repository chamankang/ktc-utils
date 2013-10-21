return unless chef_environment == "dev"

include_attribute "ktc-utils::default"

default["interface_mapping"]["management"] = "eth1"
default["interface_mapping"]["disk"] = "eth2"
default["interface_mapping"]["private"] = "eth3"
default["interface_mapping"]["public"] = "eth4"

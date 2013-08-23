return unless chef_environment == "dev"

default["interface_mapping"]["management"] = "eth1"
default["interface_mapping"]["disk"] = "eth2"
default["interface_mapping"]["private"] = "eth3"
default["interface_mapping"]["public"] = "eth4"

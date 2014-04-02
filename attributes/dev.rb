# Encoding: UTF-8
return unless chef_environment == 'dev'

include_attribute 'ktc-utils::default'

default['interface_mapping']['management'] = 'eth1'
default['interface_mapping']['disk'] = 'eth1'
default['interface_mapping']['private'] = 'eth2'
default['interface_mapping']['public'] = 'eth3'

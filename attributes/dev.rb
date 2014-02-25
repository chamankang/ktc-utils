return unless chef_environment == 'dev'

include_attribute 'ktc-utils::default'

default['interface_mapping']['management'] = 'eth0'
default['interface_mapping']['disk'] = 'eth0'
default['interface_mapping']['private'] = 'eth0'
default['interface_mapping']['public'] = 'eth0'

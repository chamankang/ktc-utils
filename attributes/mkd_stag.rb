return unless chef_environment == 'mkd_stag'

include_attribute 'ktc-utils::default'

if node.run_list.include?('recipe[ktc-compute::compute]')
  default['interface_mapping']['private'] = 'eth0'
  default['interface_mapping']['management'] = 'eth1'
  default['interface_mapping']['storage'] = 'eth2'
end

include_recipe 'services'
include_recipe 'ktc-utils'

service = node['utils_test']['service']

Services::Connection.new run_context: run_context
utils_test_service = Services::Member.new node['fqdn'], service

utils_test_service.save

utils_test_service = Services::Service.new service['service']

ha_d = node['ha_disabled']
ip, port = KTC::Attributes.get_endpoint utils_test_service, ha_d 

Chef::Log.info "# KTC::Attributes.get_endpoint test #"
Chef::Log.info "Input: #{utils_test_service}, #{ha_d}"
Chef::Log.info "Output: #{ip}, #{port}"

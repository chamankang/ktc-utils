#
# vim: set ft=ruby:
#
chef_api "https://chefdev.mkd2.ktc", node_name: "cookbook", client_key: ".cookbook.pem"

site :opscode

metadata

cookbook 'ktc-etcd'
cookbook 'services'
cookbook 'openstack-common'
cookbook 'utils_test', path: "test/cookbooks/utils_test"

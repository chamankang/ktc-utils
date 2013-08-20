#
# vim: set ft=ruby:
#
site :opscode

metadata

group 'stackforge' do
  cookbook 'openstack-common', github: 'stackforge/cookbook-openstack-common'
end

# solo-search for intgration tests
group :integration do
  cookbook 'chef-solo-search', github: 'edelight/chef-solo-search'

# add in a test cook for minitest or to twiddle an LWRP
#  cookbook 'my_cook_test', :path => './test/cookbooks/my_cook_test'
end

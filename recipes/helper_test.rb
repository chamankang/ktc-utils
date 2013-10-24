#
# Cookbook Name:: ktc-utils
# Recipe:: helper_test
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

processes = [
  { "name" => "nova-compute-long", "shortname" => "nova-compute" },
  { "name" => "libvirt-long", "shortname" => "libvirt" }
]

processes_collectd = KTC::Helpers.select_and_strip_keys processes, "shortname"

Chef::Log.info "Output: #{processes_collectd}"

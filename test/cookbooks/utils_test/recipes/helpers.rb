processes = node['utils_test']['compute']['compute_processes']

processes_collectd = KTC::Helpers.select_and_strip_keys processes, "shortname"

Chef::Log.info "# Helper test #"
Chef::Log.info "Input: #{processes}"
Chef::Log.info "Output: #{processes_collectd}"

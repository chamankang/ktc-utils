
processes = [
  { "name" => "nova-compute-long", "shortname" => "nova-compute" },
  { "name" => "libvirt-long", "shortname" => "libvirt" }
]

processes_collectd = KTC::Helpers.select_and_strip_keys processes, "shortname"

Chef::Log.info "# Helper test #"
Chef::Log.info "Input: #{processes}"
Chef::Log.info "Output: #{processes_collectd}"

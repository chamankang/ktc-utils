default["utils_test"]["compute"]["compute_processes"] = [
  { "name" => "nova-compute-long", "shortname" => "nova-compute" },
  { "name" => "libvirt-long", "shortname" => "libvirt" }
]

default["utils_test"]["service"] = {
  service: 'utils-test-service',
  port: 55555,
  proto: 'xxx',
  ip: '127.0.0.1'
}

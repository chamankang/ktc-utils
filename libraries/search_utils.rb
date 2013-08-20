# search functions

module KTCUtils

  class ::Chef::Recipe
    include ::Openstack
  end

  # Hash service data from etcd
  # return Array of ip addresses
  def get_service_ips h
    ips = Array.new
    h.each do |k, v|
      ips << h[k]["ip"]
    end
    return ips
  end

  # This method queries the rabbitmq server/s and sets the appropriate
  # attributes for the openstack service to be configured properly
  def set_rabbit_servers service
    rabbit_servers = get_members("rabbitmq")
    puts "##### Rabbit servers found: #{rabbit_servers}"
    if rabbit_servers.nil?
      return
    end
    ips = get_service_ips(rabbit_servers)
    if rabbit_servers.length == 1
      node.default["openstack"][service]["rabbit"]["host"] = ips[0]
    elsif rabbit_servers.length > 1
      node.default["openstack"][service]["rabbit"]["ha"] = true
      node.default["openstack"]["mq"]["servers"] = ips
    end
  end

  # search for nodes with the memcached role and set the appropriate attributs so
  # service sill configure themselves correctly
  def set_memcached_servers
    memcached_servers = get_members("memcached")
    puts "##### memcached servers found: #{memcached_servers}"
    unless memcached_servers.nil?
      ips = get_service_ips(memcached_servers)
      node.default["memcached"]["listen"] = ips[0]
      addr = ips.map { |x| x + ":11211" }
      node.default['openstack']['memcached_servers'] = addr
    end
  end

  # search for nodes with the database role and set the appropriate attributs so
  # service sill configure themselves correctly
  def set_database_servers service
    mysql_server = get_endpoint("mysql")
    puts "mysql server: #{mysql_server} for service #{service}"
    unless mysql_server.nil?
      node.default["openstack"]["db"][service]["host"] = mysql_server["ip"]
    end
  end

  # set the correct attr to the openstack service endpoint will bind to the right ip
  def set_service_endpoint name
    ep = get_endpoint(name)
    puts "##### #{name} service found: #{ep}"
    unless ep.nil?
      node.default["openstack"]["endpoints"][name]["host"] = ep["ip"]
      node.default["openstack"]["endpoints"][name]["port"] = ep["port"]
    end
  end

  # set the correct attr to the openstack service endpoint will bind to the right ip
  def set_service_endpoint_ip service
    address = get_interface_address("management")
    node.default["openstack"]["endpoints"][service]["host"] = address
  end
end

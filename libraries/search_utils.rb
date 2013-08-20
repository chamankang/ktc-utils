# search functions

module KTCUtils

  class ::Chef::Recipe
    include ::Openstack
  end

  # Hash service data from etcd
  # return Array of ip addresses
  def get_service_ips h
    ips = Array.new
    h.each do |k,v|
      ips << h[k]["ip"]
    end
    return ips
  end

  # This method queries the rabbitmq server/s and sets the appropriate
  # attributes for the openstack service to be configured properly
  def set_rabbit_servers service
    rabbit_servers = get_members("rabbitmq")
    puts "#####  Rabbit servers found: #{rabbit_servers}"
    if rabbit_servers.keys.length == 1
      ip = get_service_ips(rabbit_servers)[0]
      node.default["openstack"][service]["rabbit"]["host"] = ip
    elsif rabbit_servers.length > 1
      node.default["openstack"][service]["rabbit"]["ha"] = true
      ips = get_service_ips(rabbit_servers)
      node.default["openstack"]["mq"]["servers"] = ips
    end
  end

  # search for nodes with the memcached role and set the appropriate attributs so
  # service sill configure themselves correctly
  def set_memcached_servers 
    memcached_servers = get_endpoint("memcached")
    if memcached_servers.length == 1
      node.default["memcached"]["listen"] = get_service_ips(memcached_servers)[0]
    elsif memcached_servers.length > 1
      node.default["memcached"]["listen"] = get_service_ips(memcached_servers)[0]
      puts "#### TODO: deal with multiple memcached servers, just setting first for now"
    end
  end

  # search for nodes with the database role and set the appropriate attributs so
  # service sill configure themselves correctly
  def set_database_servers service
    mysql_servers = get_endpoint("mysql")
    if mysql_servers.length == 1
      node.default["openstack"]["db"][service]["host"] = get_service_ips(mysql_servers)[0]
    elsif mysql_servers.length > 1
      node.default["openstack"]["db"][service]["host"] = get_service_ips(mysql_servers)[0]
      puts "#### TODO: deal with multiple mysql servers, just setting first for now"
    end
  end

  # set the correct attr to the openstack service endpoint will bind to the right ip
  def set_service_endpoint_ip service
    node.default["openstack"]["endpoints"][service]["host"] = get_interface_address("management")
  end
end


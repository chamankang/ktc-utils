# search functions

module KTCUtils

  class ::Chef::Recipe
    include ::Openstack
  end

  # This method queries the rabbitmq server/s and sets the appropriate
  # attributes for the openstack service to be configured properly
  def set_rabbit_servers service, r="ktc-messaging"
    rabbit_servers = search_for r
    puts "#####  Rabbit servers found: #{rabbit_servers}"
    if rabbit_servers.length == 1
      ip = get_interface_address("management", rabbit_servers.first)
      node.default["openstack"][service]["rabbit"]["host"] = ip
    elsif rabbit_servers.length > 1
      node.default["openstack"][service]["rabbit"]["ha"] = true
      ips = []
      rabbit_servers.each do |s|
        ips << get_interface_address("management", s)
      end
      node.default["openstack"]["mq"]["servers"] = ips
    end
  end

  # search for nodes with the memcached role and set the appropriate attributs so
  # service sill configure themselves correctly
  def set_memcached_servers r="infra-caching"
    memcached_servers = search_for r
    if memcached_servers.length == 1
      node.default["memcached"]["listen"] = get_interface_address("management", memcached_servers.first)
    elsif memcached_servers.length > 1
      node.default["memcached"]["listen"] = get_interface_address("management", memcached_servers.first)
      puts "#### TODO: deal with multiple memcached servers, just setting first for now"
    end
  end

  # search for nodes with the database role and set the appropriate attributs so
  # service sill configure themselves correctly
  def set_database_servers service, r="ktc-database"
    mysql_servers = search_for r
    if mysql_servers.length == 1
      node.default["openstack"]["db"][service]["host"] = get_interface_address("management", mysql_servers.first)
    elsif mysql_servers.length > 1
      node.default["openstack"]["db"][service]["host"] = get_interface_address("management", mysql_servers.first)
      puts "#### TODO: deal with multiple mysql servers, just setting first for now"
    end
  end

  # set the correct attr to the openstack service endpoint will bind to the right ip
  def set_service_endpoint_ip service
    node.default["openstack"]["endpoints"][service]["host"] = get_interface_address("management")
  end
end

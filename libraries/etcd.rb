# functions for dealing with etcd

module KTCUtils

  # Initialize etcd client
  def init_etcd
    chef_gem "etcd" do
      action :install
    end

    require "etcd"

    ip = node["etcd"]["ip"]
    port = node["etcd"]["port"]
    return Etcd.client(:host=>ip, :port=>port)
  end

  # Register a service with etcd
  # service_name String name of the service
  # data Hash containing the service data
  def register_member member_name, data
    client = init_etcd
    data.each do |k, v|
      begin
        path = "/openstack/services/#{member_name}/members/#{node["fqdn"]}/#{k}"
        puts "adding key #{path}"
        client.set(path, v)
      rescue
        puts "enable to contact etcd server"
      end
    end
  end

  # extra member data from a path in etcd
  def get_member_data client, base
    data = Hash.new
    node = base["key"].split("/").last
    ep = client.get(base["key"])
    ep.each do |k|
      data[k["key"].split("/").last] = k.value
    end
    return { node=>data }
  end

  # obtain service information from etcd
  # service_name String name of service to retreive info on
  # return Hash keys are the nodes names, value are data
  def get_members member_name
    client = init_etcd
    base_path = "/openstack/services/#{member_name}/members"
    begin
      base = client.get(base_path)
      # if only one endpoint is returns ep will be a Mash, more than one, an Array
      if base.class == Hashie::Mash
        return get_member_data(client, base)
      elsif base.class == Array
        nodes = Hash.new
        base.each do |a|
          nodes.merge!(get_member_data(client, a))
        end
        return nodes
      end
    rescue
      puts "unable to contact etcd server"
    end
  end

  def get_endpoint name
    #m = get_members(name)
    #return m.values[0]
    begin
      client = init_etcd
      ep = Hash.new
      base_path = "/openstack/services/#{name}/endpoint"
      %w/
        ip
        port
        proto
        uri
      /.each do |k|
        ep[k] = client.get("#{base_path}/#{k}").value
      end
      return ep
    rescue
      Chef::Log.info("error getting service endpoint")
      return {}
    end
  end

  # common service template with some defaults
  def get_openstack_service_template ip, port
    d = Hash.new
    d["ip"] = ip
    d["port"] = port
    d["proto"] = "http"
    return d
  end

end

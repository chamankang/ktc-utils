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
  def register_service service_name, data
    client = init_etcd
    data.each do |k,v|
      begin
        puts "adding key /openstack/services/#{service_name}/members/#{node.fqdn}/#{k}"
        client.set("/openstack/services/#{service_name}/members/#{node.fqdn}/#{k}", v)
      rescue
        puts "enable to contact etcd server"
      end
    end
  end

  # obtain service information from etcd
  # service_name String name of service to retreive info on
  # return Hash keys are the nodes names, value are data
  def get_service service_name
    client = init_etcd
    base_path = "/openstack/services/#{service_name}/members"
    begin
      base = client.get(base_path)
      # if only one endpoint is returns ep will be a Mash, more than one, an Array
      # TODO: refactorinto more methods,  use  responds_to? instead of class inspection
      if base.class == Hashie::Mash
        ep = client.get(base["key"])
        node = base["key"].split("/").last
        data = Hash.new
        ep.each do |k|
          data[k["key"].split("/").last] = k.value
        end
        return { node=>data }
      elsif base.class == Array
        nodes = Hash.new
        base.each do |a|
          node = a["key"].split("/").last
          ep = client.get(a["key"])
          data = Hash.new
          ep.each do |k|
            data[k["key"].split("/").last] = k.value
          end
          nodes[node] = data
        end
        return nodes
      end
    rescue
      puts "unable to contact etcd server"
    end
  end

  # common service template with some defaults
  def get_openstack_service_template ip, port
    d = Hash.new
    d["ip"] = ip
    d["port"] = port
    d["protocol"] = "http"
    return d
  end

end

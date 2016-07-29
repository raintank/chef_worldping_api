module ChefWorldpingApi
  module Helpers
    def find_haproxy
      return nil? unless node.attribute?('gce')
      zone = node['gce']['instance']['zone']
      haproxy = search("node", node['chef_base']['haproxy_search'])
      h = haproxy.select { |h| h['gce']['instance']['zone'] == zone }.first
      return (h) ? h.ipaddress : nil
    end
    def find_nsqd(port=4150)
      if Chef::Config[:solo] || node['chef_base']['standalone']
	return [ "127.0.0.1:#{port}" ]
      end
      # eventually we'll want to limit this search to only the same zone
      nsqds = search("node", node['chef_base']['nsqd_search'])
      return nsqds.map { |n| "#{n.fqdn}:#{port}" }
    end
    def find_cassandras
      if Chef::Config[:solo] || node['chef_base']['standalone']
         return [ "127.0.0.1" ]
      end
      cassandras = search("node", node['chef_base']['cassandra_search'])
      return cassandras.map { |c| c.fqdn }
    end
  end
end

Chef::Recipe.send(:include, ::ChefWorldpingApi::Helpers)
Chef::Resource.send(:include, ::ChefWorldpingApi::Helpers)
Chef::Provider.send(:include, ::ChefWorldpingApi::Helpers)

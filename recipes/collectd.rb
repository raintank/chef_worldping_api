if node['use_collectd']
  execs = []
  execs.push %Q("nobody" "/usr/share/collectd/plugins/worldping-run" )
  node.set['collectd']['plugins']['exec']['config']['Exec'] = execs
end

directory "/usr/share/collectd/plugins" do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
  only_if { node['use_collectd'] }
end

if node['use_collectd'] && node['collectd']['plugins']['exec']
  execs = []
  execs.push %Q("nobody" "/usr/share/collectd/plugins/worldping-run" )
  node.set['collectd']['plugins']['exec']['config']['Exec'] = execs
end

template "/usr/share/collectd/plugins/worldping-run" do
  source 'worldping-run.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables({
    :api_key => node['chef_worldping_api']['admin_key']
  })
  only_if { node['use_collectd'] }
  action :create  
end

node.set["collectd_personality"] = "worldping-api"
include_recipe "chef_base::collectd"

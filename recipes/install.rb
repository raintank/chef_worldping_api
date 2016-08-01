group node[:chef_worldping_api]['group'] do
  system true
  action :create
  not_if "getent group #{node[:chef_worldping_api]['group']}"
end

user node[:chef_worldping_api]['user'] do
  system true
  gid node[:chef_worldping_api]['group']
  home node[:chef_worldping_api]['data_dir']
  action :create
  not_if "getent passwd #{node[:chef_worldping_api]['user']}"
end

packagecloud_repo node[:chef_base][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['chef_worldping_api']['package_version']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

directory node[:chef_worldping_api]['log_dir'] do
  owner node[:chef_worldping_api]['user']
  group node[:chef_worldping_api]['group']
  mode "0755"
  recursive true
  action :create
end

directory node[:chef_worldping_api]['data_dir'] do
  owner node[:chef_worldping_api]['user']
  group node[:chef_worldping_api]['group']
  mode "0755"
  recursive true
  action :create
end

package "worldping-api" do
  version pkg_version
  action pkg_action
  options "-o Dpkg::Options::='--force-confnew'"
end

service "worldping-api" do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 15.04
      provider Chef::Provider::Service::Systemd
    elsif node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [ :enable, :start ]
end

elasticsearch_host = find_haproxy || node['grafana']['elasticsearch_host']
db_host = find_haproxy || node['grafana']['db_host']
rabbitmq_host = find_haproxy || node['grafana']['rabbitmq_host']
graphite_host = find_haproxy || node['grafana']['graphite_host']
kafka_host = find_haproxy || node['chef_worldping_api']['kafka_host']

node.default[:chef_worldping_api]['instance_id'] = node['hostname']

template "/etc/raintank/worldping-api.ini" do
  source 'worldping-api.ini.erb'
  mode '600'
  owner node[:chef_worldping_api]['user']
  group node[:chef_worldping_api]['group']
  variables({
    db_host: db_host,
    elasticsearch_host: elasticsearch_host,
    rabbitmq_host: rabbitmq_host,
    graphite_host: graphite_host,
    kafka_host: kafka_host
  })
  notifies :restart, 'service[worldping-api]', :delayed
end




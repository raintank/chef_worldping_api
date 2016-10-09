include_recipe 'nginx::repo'
include_recipe 'nginx'

include_recipe 'chef_base::ssl_updates'
include_recipe 'chef_base::dhparams'

# create ssl cert files if we're doing that
if node['chef_worldping_api']['nginx']['use_ssl']
  directory "/etc/nginx/ssl" do
    owner node['nginx']['user']
    group node['nginx']['group']
    mode '0700'
    action :create
  end

  # Later: this should use chef-vault instead of encrypted data bags
  certs = Chef::EncryptedDataBagItem.load(:grafana_ssl_certs, node['chef_worldping_api']['nginx']['ssl_data_bag']).to_hash
  cert_file = node['chef_worldping_api']['nginx']['ssl_cert_file']
  cert_key = node['chef_worldping_api']['nginx']['ssl_key_file']
  file node['chef_worldping_api']['nginx']['ssl_cert_file'] do
    owner node['nginx']['user']
    group node['nginx']['group']
    mode '0600'
    content certs['ssl_cert']
    action :create
  end
  file node['chef_worldping_api']['nginx']['ssl_key_file'] do
    owner node['nginx']['user']
    group node['nginx']['group']
    mode '0600'
    content certs['ssl_key']
    action :create
  end
end

# nginx on first boot
execute "nginx-stop-and-kill" do
  creates "/etc/nginx/firstboot"
  command "touch /etc/nginx/firstboot && service nginx stop && killall -9 nginx || echo 'not killed'"
  ignore_failure true
  notifies :start, "service[nginx]", :immediately
end

gn_source = if node['chef_worldping_api']['nginx']['use_ssl']
  "app_worldping_api_ssl.conf.erb"
else
  "app_worldping_api.conf.erb"
end

template "/etc/nginx/sites-available/worldping_api" do
  source gn_source
end

nginx_site 'default' do
  enable false
end

nginx_site "worldping_api" do
  notifies :restart, 'service[nginx]'
end


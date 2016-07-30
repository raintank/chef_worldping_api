############ Worldping-api 

### INSTALL ###
default[:chef_worldping_api]['user'] = 'grafana'
default[:chef_worldping_api]['group'] = 'grafana'

default[:chef_worldping_api]['instance_id'] = 'default'

### PATHS ###
default[:chef_worldping_api]['log_dir'] = '/var/log/grafana'
default[:chef_worldping_api]['data_dir'] = '/var/lib/grafana'
default[:chef_worldping_api]['static_root'] = 'public'

### SERVER ###
default[:chef_worldping_api]['port'] = '3000'
default[:chef_worldping_api]['protocol'] = 'http'
default[:chef_worldping_api]['domain'] = "localhost"
default[:chef_worldping_api]['app_mode'] = 'production'
default[:chef_worldping_api]['root_url'] = '%(protocol)s://%(domain)s:%(http_port)s/'
default[:chef_worldping_api]['router_logging'] = false
default[:chef_worldping_api]['enable_gzip'] = false
default[:chef_worldping_api]['admin_key'] = 'changeme'
default[:chef_worldping_api]['backend'] = "localhost:3001"

### DB ###
default[:chef_worldping_api]['db_type'] = 'sqlite3' # Either mysql, postgres, or sqlite3
default[:chef_worldping_api]['db_file'] = 'grafana.db'
default[:chef_worldping_api]['db_name'] = 'grafana'
default[:chef_worldping_api]['db_host'] = 'localhost'
default[:chef_worldping_api]['db_port'] = 3306 # ip/hostname:port, Only for mysql/postgres
default[:chef_worldping_api]['db_user'] = 'grafana_user' # Only for mysql/postgres
default[:chef_worldping_api]['db_password'] = 'SECRET'   # Only for mysql/postgres

### SMTP ###
default[:chef_worldping_api]['smtp']['enabled'] = false
default[:chef_worldping_api]['smtp']['host'] = ''
default[:chef_worldping_api]['smtp']['user'] = ''
default[:chef_worldping_api]['smtp']['password'] = ''
default[:chef_worldping_api]['smtp']['cert_file'] = ''
default[:chef_worldping_api]['smtp']['key_file'] = ''
default[:chef_worldping_api]['smtp']['from_address'] = 'admin@grafana.localhost'

### EMAIL ###
default[:chef_worldping_api]['email']['welcome_email'] = false
default[:chef_worldping_api]['email']['templates_pattern'] = 'emails/*.html'

### LOGGING ###
default[:chef_worldping_api]['log_level'] = 'Info' # Either "Trace", "Debug", "Info", "Warn", "Error", "Critical"
default[:chef_worldping_api]['log_level_console' ] = node[:chef_worldping_api]['log_level']
default[:chef_worldping_api]['log_level_file' ] = node[:chef_worldping_api]['log_level']
default[:chef_worldping_api]['log_mode'] = "console"

### EVENT PUBLISHING
default[:chef_worldping_api]['event_publish'] = true
default[:chef_worldping_api]['rabbitmq_host'] = 'localhost'
default[:chef_worldping_api]['event_exchange'] = 'grafana_events'
default[:chef_worldping_api]['alerts_exchange'] = 'wp_alerts'

### RAINTANK ###
default[:chef_worldping_api]['raintank'] = true
default[:chef_worldping_api]['graphite_host'] = 'localhost'
default[:chef_worldping_api]['graphite_port'] = 8888
default[:chef_worldping_api]['elasticsearch_host'] = 'localhost'

default[:chef_worldping_api]['haproxy_search'] = "tags:haproxy AND chef_environment:#{node.chef_environment}"

### TELEMETRY
default[:chef_worldping_api]['use_statsd'] = false
default[:chef_worldping_api]['statsd_addr'] = "localhost:8125"
default[:chef_worldping_api]['statsd_type'] = "standard"

### PROFILING
default[:chef_worldping_api]['use_profiling'] = false
default[:chef_worldping_api]['profile_heap_mb'] = 4000
default[:chef_worldping_api]['profile_heap_dir'] = '/tmp/worldping-api-profile'
default[:chef_worldping_api]['profile_heap_wait'] = 3600

### ALERTING
default[:chef_worldping_api]['alerting']['enabled'] = false
default[:chef_worldping_api]['alerting']['handler'] = "amqp"
default[:chef_worldping_api]['alerting']['queue_ticks_size'] = 20
default[:chef_worldping_api]['alerting']['queue_jobs_size'] = 1000
default[:chef_worldping_api]['alerting']['pre_amqp_jobs_size'] = 1000
default[:chef_worldping_api]['alerting']['executor_lru_size'] = 10000
default[:chef_worldping_api]['alerting']['enable_scheduler'] = false
default[:chef_worldping_api]['alerting']['executors'] = 10
default[:chef_worldping_api]['alerting']['individual_alerts'] = false

### QUOTAS
default[:chef_worldping_api]['quota']['enabled'] = true
default[:chef_worldping_api]['quota']['org_endpoint'] = 10
default[:chef_worldping_api]['quota']['org_probe'] = 10
default[:chef_worldping_api]['quota']['global_endpoint'] = -1
default[:chef_worldping_api]['quota']['global_probe'] = -1

# nginx
default[:chef_worldping_api][:nginx][:use_ssl] = false
default[:chef_worldping_api][:nginx][:ssl_cert_file] = "/etc/nginx/ssl/grafana.crt"
default[:chef_worldping_api][:nginx][:ssl_key_file] = "/etc/nginx/ssl/grafana.key"
default[:chef_worldping_api][:nginx][:ssl_data_bag] = node[:chef_worldping_api][:domain]

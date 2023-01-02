server ENV['SECRETS_DEPLOY_IP'], user: ENV['SECRETS_DEPLOY_USER'], roles: %w[app db web]
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
append :linked_files, 'log/production.log'

set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_default_control_app, "unix://#{shared_path}/tmp/sockets/pumactl.sock"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"
set :puma_service_unit_name, 'puma_spektr_secrets_production'

# config valid for current version and patch releases of Capistrano
lock '~> 3.17.0'

set :application, 'secrets'
set :repo_url, 'https://github.com/spektrhq/secrets'
set :deploy_to, ENV['SECRETS_DEPLOY_TO']

set :linked_files, %w[.env config/master.key]
append :linked_dirs, 'tmp'

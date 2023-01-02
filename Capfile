# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'

require 'capistrano/puma'
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Nginx
install_plugin Capistrano::Puma::Systemd

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '3.1.2'
set :rbenv_path, '~/.rbenv'
set :rbenv_prefix,
    "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]
set :rbenv_roles, :all # default value

set :puma_systemctl_user, :spektr
set :puma_lingering_user, :spektr

require 'dotenv'
Dotenv.load

set :assets_manifests, ['.manifest.json']

namespace :deploy do
  desc 'Normalize asset timestamps'
  task normalize_assets: [:set_rails_env] do
    on release_roles(fetch(:assets_roles)) do
      assets = Array(fetch(:normalize_asset_timestamps, []))
      if assets.any?
        within release_path do
          execute :find, "#{assets.join(' ')} -exec touch -t #{asset_timestamp} {} ';'; true"
        end
      end
    end
  end

  desc 'Compile assets'
  task compile_assets: [:set_rails_env] do
    invoke 'deploy:assets:precompile'
    invoke 'deploy:assets:backup_manifest'
  end

  desc 'Cleanup expired assets'
  task cleanup_assets: [:set_rails_env] do
    next unless fetch(:keep_assets)

    on release_roles(fetch(:assets_roles)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "'assets:clean[#{fetch(:keep_assets)}]'"
        end
      end
    end
  end

  desc 'Clobber assets'
  task clobber_assets: [:set_rails_env] do
    on release_roles(fetch(:assets_roles)) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'assets:clobber'
        end
      end
    end
  end

  desc 'Rollback assets'
  task rollback_assets: [:set_rails_env] do
    invoke 'deploy:assets:restore_manifest'
  rescue Capistrano::FileNotFound
    invoke 'deploy:compile_assets'
  end

  after 'deploy:updated', 'deploy:compile_assets'
  after 'deploy:updated', 'deploy:cleanup_assets'
  after 'deploy:updated', 'deploy:normalize_assets'
  after 'deploy:reverted', 'deploy:rollback_assets'

  namespace :assets do
    task :precompile do
      on release_roles(fetch(:assets_roles)) do
        within release_path do
          with rails_env: fetch(:rails_env), rails_groups: fetch(:rails_assets_groups) do
            execute :rake, 'assets:precompile'
          end
        end
      end
    end

    task :backup_manifest do
      on release_roles(fetch(:assets_roles)) do
        within release_path do
          backup_path = release_path.join('assets_manifest_backup')

          execute :mkdir, '-p', backup_path
          execute :cp,
                  detect_manifest_path,
                  backup_path
        end
      end
    end

    task :restore_manifest do
      on release_roles(fetch(:assets_roles)) do
        within release_path do
          targets = detect_manifest_path.split(' ')
          sources = targets.map do |target|
            release_path.join('assets_manifest_backup', File.basename(target))
          end
          if test(:ls, *sources) && test(:ls, *targets)
            source_map = sources.zip(targets)
            source_map.each do |source, target|
              execute :cp, source, target
            end
          else
            msg = 'Rails assets manifest file (or backup file) not found.'
            warn msg
            raise Capistrano::FileNotFound, msg
          end
        end
      end
    end

    def detect_manifest_path
      fetch(:assets_manifests).each do |candidate|
        return capture(:ls, candidate).strip.gsub(/(\r|\n)/, ' ') if test(:ls, candidate)
      end
      msg = 'Rails assets manifest file not found.'
      warn msg
      raise Capistrano::FileNotFound, msg
    end
  end
end

# we can't set linked_dirs in load:defaults,
# as assets_prefix will always have a default value
namespace :deploy do
  task :set_linked_dirs do
    linked_dirs = fetch(:linked_dirs, [])
    unless linked_dirs.include?('public')
      linked_dirs << "public/#{fetch(:assets_prefix)}"
      set :linked_dirs, linked_dirs.uniq
    end
  end
end

after 'deploy:set_rails_env', 'deploy:set_linked_dirs'

namespace :load do
  task :defaults do
    set :assets_roles, fetch(:assets_roles, [:web])
    set :assets_prefix, fetch(:assets_prefix, 'assets')
    set :assets_manifests, lambda {
      %w[.manifest*.*].map do |pattern|
        release_path.join('public', fetch(:assets_prefix), pattern)
      end
    }
  end
end

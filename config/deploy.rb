# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'playhard_core'
set :repo_url, 'git@github.com:Bor1s/playhard-core.git'

set :rbenv_type, :user
set :rbenv_ruby, '2.1.2'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

#set :linked_files, ['config/mongoid.yml']

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

set :bower_flags, '--quiet --config.interactive=false'
set :bower_roles, :web
set :bower_target_path, nil

namespace :deploy do

 def run_unicorn
    within release_path do
      with rails_env: fetch(:stage) do
        execute "#{fetch(:bundle_binstubs)}/unicorn_rails", "-c #{release_path}/config/unicorn.rb -D -E #{fetch(:stage)}"
      end
    end
  end

  def stop_unicorn
    within release_path do
      if test "[ -f #{fetch(:deploy_to)}/shared/tmp/pids/unicorn.pid ]"
        execute :kill, "-QUIT `cat #{fetch(:deploy_to)}/shared/tmp/pids/unicorn.pid`"
      end
    end
  end

  def reindex_solr
    within release_path do
      with rails_env: fetch(:rails_env) do
        warn 'Reindexing Solr ...'
        execute :rake, "solr:reindex"
      end
    end
  end

  def reboot_solr
    within release_path do
      solr_conf = release_path.join('config', 'solr', 'solrconfig.xml')
      solr_schema = release_path.join('config', 'solr', 'schema.xml')
      target = '/opt/solr/playhard/multicore/core0/conf'

      warn 'Trying to copy configs ...'
      if test "[[ -f #{solr_conf} && -f #{solr_schema} ]]"
        warn solr_conf
        warn solr_schema
        warn target
        execute :cp, '-R', solr_conf, target
        execute :cp, '-R', solr_schema, target
        execute 'sudo service tomcat6 stop && sudo service tomcat6 start'
      else
        msg = 'Solr configs are not found in app config folder!'
        warn msg
        fail Capistrano::FileNotFound, msg
      end
    end
  end



  desc 'Reindex solr'
  task :reindex_solr do
    on roles(:app) do
      reindex_solr
    end
  end
 
  desc 'Copy solr schema and config'
  task :reboot_solr do
    on roles(:app) do
      reboot_solr
    end
  end

  desc 'Start applicaction'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      run_unicorn
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      stop_unicorn
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      if test "[ -f #{fetch(:deploy_to)}/shared/tmp/pids/unicorn.pid ]"
        stop_unicorn
      else
        run_unicorn
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  before :finishing, :reboot_solr
  after :finishing, :reindex_solr

end

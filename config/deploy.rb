# coding: UTF-8

# Please install the Engine Yard Capistrano gem
# gem install eycap --source http://gems.engineyard.com
require "eycap/recipes"

set :keep_releases, 5
#set :application,   'JobUmbrellaDevelopment'
set :repository,    'http://svn-del.globallogic.com/projects/J4S/source/hilo/'
#set :deploy_to,     "/data/#{application}"
set :deploy_via,    :copy
#set :monit_group,   "#{application}"
set :scm,           :subversion

set :scm_username,     "puneet.pandey"
set :scm_password,     ""

#set :repository_cache, "/var/cache/engineyard/#{application}"

set :git_enable_submodules, 1
# This is the same database name for all environments
#set :production_database,'JobUmbrellaDevelopment_production'

set :environment_host, 'localhost'

# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
default_run_options[:pty] = true # required for svn+ssh:// andf git:// sometimes

# This will execute the Git revision parsing on the *remote* server rather than locally
#set :real_revision, 			lambda { source.query_revision(revision) { |cmd| capture(cmd) } }

task :hilo_staging do
 set :application,   'hiloStaging'
 set :deploy_to,     "/data/#{application}"
 set :monit_group,   "#{application}"
 set :repository_cache, "/var/cache/engineyard/#{application}"
 set :staging_database, 'hiloStaging'

 role :web, '107.21.237.65'
 role :app, '107.21.237.65'
 role :db, '107.21.237.65', :primary => true
 set :environment_database, Proc.new { staging_database }
 set :dbuser,        'deploy'
 set :dbpass,        '6BKV4meGJ2'
 set :user,          'deploy'
 set :password,      '6BKV4meGJ2'
 set :runner,        'deploy'
 set :rails_env,     'staging'
end

task :hilo_production do
  set :application,   'hiloProduction'
  set :deploy_to,     "/data/#{application}"
  set :monit_group,   "#{application}"
  set :repository_cache, "/var/cache/engineyard/#{application}"
  set :production_database,'hiloProduction'

  role :web, '107.22.227.156'
  role :app, '107.22.227.156'
  role :db, '107.22.227.156', :primary => true
  set :environment_database, Proc.new { production_database }
  set :dbuser,        'deploy'
  set :dbpass,        '3MxeYjsVac'
  set :user,          'deploy'
  set :password,      '3MxeYjsVac'
  set :runner,        'deploy'
  set :rails_env,     'production'
end

task :TheHiloProject do
  set :application,   'TheHiloProject'
  set :deploy_to,     "/data/#{application}"
  set :monit_group,   "#{application}"
  set :repository_cache, "/var/cache/engineyard/#{application}"
  set :production_database,'TheHiloProject'

  role :web, '50.16.210.180'
  role :app, '50.16.210.180'
  #role :db, 'ec2-50-16-16-1.compute-1.amazonaws.com', :primary => true, :no_release => true

  role :db,  "50.16.210.180", :primary => true
  #role :db,  "ec2-50-16-16-1.compute-1.amazonaws.com", :primary => true, :no_release => false

  set :environment_database, Proc.new { production_database }
  set :dbuser,        'deploy'
  set :dbpass,        'DYbkE2eG1V'
  set :user,          'deploy'
  set :password,      'DYbkE2eG1V'
  set :runner,        'deploy'
  set :rails_env,     'production'
end

# TASKS
# Don't change unless you know what you are doing!

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:update_code","deploy:symlink_configs"

namespace :nginx do
  task :start, :roles => :app do
    sudo "nohup /etc/init.d/nginx start > /dev/null"
  end

  task :restart, :roles => :app do
    sudo "nohup /etc/init.d/nginx restart > /dev/null"
  end
end

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end
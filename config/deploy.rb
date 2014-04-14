
require "rvm/capistrano"
require "bundler/capistrano"
set :application, "192.5.31.100"
set :deploy_to, "/home/nginx01/velvet#{application}"
set :repository,  "git@heroku.com:velvet-betav1.git"
set :port, 3000
set :use_sudo, true
set :user_sudo, false
set :rails_env, "production" # sets your server environment to Production mode
set :ssh_options, { :forward_agent => true }
set :scm, :git  # sets version control

default_run_options[:pty] = true
set :user, "nginx01"
role :web, application
role :app, application
role :db,  application, :primary => true

after "deploy:restart", "deploy:cleanup"
after "deploy", "rvm:trust_rvmrc"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Create Solr Directory"
  task :setup_solr_data_dir do
    run "mkdir -p #{shared_path}/solr/data"
  end
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end
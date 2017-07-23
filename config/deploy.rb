# config valid only for current version of Capistrano
lock '3.8.2'

set :application, 'translator'
set :repo_url, 'git@github.com:kortirso/translator.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/html/translator'
set :deploy_user, 'kortirso'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/application.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

namespace :deploy do
    desc 'Restart application'
    task :restart do
        on roles(:app), in: :sequence, wait: 5 do
            execute :touch, release_path.join('tmp/restart.txt')
        end
    end

    namespace :assets do
        desc "Precompile assets"
        task :precompile do
            on roles(:app) do
                invoke 'deploy:assets:precompile_locally_archive'
                #Rake::Task["deploy:assets:precompile_locally_archive"].invoke
            end
        end    
    end

    namespace :assets do
        desc 'Precompile assets locally and upload to server'
        task :precompile_locally_copy do
            on roles(:app) do
                run_locally do
                    with rails_env: fetch(:rails_env) do
                        #execute 'rake assets:precompile'
                    end
                end

                execute "cd #{release_path} && mkdir public" rescue nil
                execute "cd #{release_path} && mkdir public/assets" rescue nil
                execute 'rm -rf public/assets/*'

                upload! 'public/assets', "#{release_path}/public", recursive: true

            end
        end
    end

    after :publishing, :restart
end

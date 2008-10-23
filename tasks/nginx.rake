
namespace :nginx do
  desc "Install nginx config"
  remote_task :setup do
    run "sudo ln -s -f #{DEPLOY_ROOT}/current/config/mushub/mushub_services.nginx.conf /etc/nginx/sites-enabled/mushub_services.nginx.conf.conf"
  end
  
  desc "Restart nginx"
  remote_task :restart do
    run "sudo /etc/init.d/nginx restart"
  end
end

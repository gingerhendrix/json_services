
namespace :god do
  desc "Install god config"
  remote_task :setup do
    run "sudo ln -s -f #{DEPLOY_ROOT}/current/config/mushub/mushub_services.god /etc/god/services/mushub_services.god"
  end
  
  desc "Restart god"
  remote_task :restart do
    run "sudo /etc/init.d/god restart"
  end
end

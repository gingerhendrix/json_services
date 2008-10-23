
namespace :god do
  desc "Install god config"
  remote_task :setup do
    run "sudo ln -s -f #{DEPLOY_ROOT}/current/config/mushub/mushub_services.god /etc/god/services/mushub_services.god"
  end
  
  desc "Restart god"
  remote_task :restart_god do
    run "sudo /etc/init.d/god restart"
  end
  
  desc "Restart mushub_services"
  remote_task :restart_mushub_services do
    run "sudo god restart mushub_services"
  end
  
  desc "Print God status"
  remote_task :status do
    run "sudo god status"
  end


end

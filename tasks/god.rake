
namespace :god do
  desc "Install god config"
  remote_task :setup do
    run "sudo ln -s -f #{DEPLOY_ROOT}/current/config/mushub/mushub_services.god /etc/god/services/mushub_services.god"
    run "sudo ln -s -f #{DEPLOY_ROOT}/current/config/mushub/mushub_services_worker.god /etc/god/services/mushub_services_worker.god"
    run "sudo ln -s -f #{DEPLOY_ROOT}/current/config/mushub/starling.god /etc/god/services/starling.god"
  end
  
  desc "Restart god"
  remote_task :restart_god do
    run "sudo /etc/init.d/god restart"
  end

  remote_task :start_god do
    run "sudo /etc/init.d/god start"
  end
  
  desc "Restart mushub_services"
  remote_task :restart_mushub_services do
    run "sudo god restart mushub_services"
  end
  
  desc "Restart mushub_services_worker"
  remote_task :restart_mushub_services_worker do
    run "sudo god restart mushub_services_worker"
  end
  
  desc "Restart starling"
  remote_task :restart_starling do
    run "sudo god restart starling"
  end
  
  desc "Print God status"
  remote_task :status do
    run "sudo god status"
  end


end

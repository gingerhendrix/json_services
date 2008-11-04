

namespace :starling do
  desc "Starling statistics"
  remote_task :top do
    run "sudo starling_top"
  end
end

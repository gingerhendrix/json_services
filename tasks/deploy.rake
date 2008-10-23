

def archive
  commit = `git-rev-list --max-count=1 --abbrev=10 --abbrev-commit HEAD`.chomp
  file = "#{APP_NAME}-#{commit}.tar.gz"
end

namespace :deploy do
  task :build do
    sh "tar c . | gzip > #{archive}"
  end

  remote_task :push => :build do
    rsync archive, "/tmp"
  end

  desc "Install a release from the latest commit"
  remote_task :install => :push do
    date_stamp = Time.now.strftime("%Y%m%d")
    last_release = run("ls #{DEPLOY_ROOT}/rels | sort -r | head -n 1").chomp

    if last_release =~ /#{date_stamp}\-(\d+)/
      serial = $1.to_i + 1
    else
      serial = 0 
    end

    rel = ("%d-%02d" % [date_stamp, serial])
    rel_dir = "#{DEPLOY_ROOT}/rels/#{rel}"
    
    run "mkdir -p #{rel_dir}"
    run "tar -xzvf /tmp/#{archive} -C #{rel_dir} && rm -rf /tmp/#{archive}"
    run "ln -s -f -T #{rel_dir} #{DEPLOY_ROOT}/current"
    run "ln -s -f -T #{DEPLOY_ROOT}/current/config/mushub/config.rb #{DEPLOY_ROOT}/current/config/config.rb"

  end
  
  desc "Restart the server"
  remote_task :restart do
    restart_daemons
  end
  
  desc "Rollback to the previous release"
  remote_task :rollback do
    current_link = run("ls -alF #{DEPLOY_ROOT} | awk '/current -> .*/ { print $NF }'").chomp
    current = File.basename(current_link)
    releases = run("ls #{DEPLOY_ROOT}/rels | sort -r").split("\n")
    previous = releases.find {|rel| current > rel}
    raise "No previous release" if previous.nil?
    run "sudo ln -s -f -T #{DEPLOY_ROOT}/rels/#{previous} #{DEPLOY_ROOT}/current"
    restart_daemons
    puts "Moved to #{previous}"
  end

  desc "Rollforward to the next release"
  remote_task :rollforward do
    current_link = run("ls -alF #{DEPLOY_ROOT} | awk '/current -> .*/ { print $NF }'").chomp
    current = File.basename(current_link)
    releases = run("ls #{DEPLOY_ROOT}/rels | sort -r").split("\n")
    next_rel = releases.find {|rel| current < rel}
    raise "No next release" if next_rel.nil?
    run "sudo ln -s -f -T #{DEPLOY_ROOT}/rels/#{next_rel} #{DEPLOY_ROOT}/current"
    restart_daemons
    puts "Moved to #{next_rel}"
  end
end


require 'rubygems'
begin
  require 'rake'
rescue LoadError
  puts 'This script should only be accessed via the "rake" command.'
  puts 'Installation: gem install rake -y'
  exit
end
require 'rake'
require 'rake/clean'
require 'rake/packagetask'
require 'rake_remote_task'


$:.unshift File.dirname(__FILE__) + "/tasks/lib"

APP_VERSION  = '0.4.0'
APP_NAME     = 'mushub_services'

APP_ROOT     = File.expand_path(File.dirname(__FILE__))

DEPLOY_ROOT = "/var/web/apps/#{APP_NAME}"

ON_DEPLOY_RESTART = []

APP_SERVER = "linode.gandrew.com"
role :app_server, APP_SERVER

JS_SRC_DIR = File.dirname(__FILE__) + "/js/NowPlaying"

Dir['tasks/**/*.rake'].each { |rake| load rake }





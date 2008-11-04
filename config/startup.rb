
require 'rubygems'

$:.unshift(File.dirname(__FILE__) + "/../lib") 

Dir.glob(File.dirname(__FILE__) + '/../vendor/gems/*') { |d|
  $:.unshift d + "/lib"
  require d + "/lib/" + File.basename(d) + ".rb"  
}

require File.dirname(__FILE__) + '/../config/config.rb'

include Server::DSL

Dir.glob(File.dirname(__FILE__) + '/../lib/json_services/*.rb') { 
  |f| require f 
}

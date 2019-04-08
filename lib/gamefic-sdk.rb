require 'gamefic'
require 'gamefic-sdk/version'

module Gamefic::Sdk
  autoload :Server, 'gamefic-sdk/server'
  autoload :Diagram, 'gamefic-sdk/diagram'
  autoload :Scaffold, 'gamefic-sdk/scaffold'

  SCAFFOLDS_PATH = File.realpath(File.join(File.dirname(__FILE__), '..', 'scaffolds'))
end

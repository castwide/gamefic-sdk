require 'thor'

module Gamefic
  module Sdk
    class Shell < Thor
      map %w[--version -v] => :version
      map %i[create new init] => :project

      desc "--version, -v", "Print the version"
      def version
        puts "gamefic-sdk #{Gamefic::Sdk::VERSION}"
        puts "gamefic #{Gamefic::VERSION}"
      end

      desc 'project DIRECTORY_NAME', 'Create a new project in DIRECTORY_NAME'
      option :specs, type: :boolean, desc: 'Add RSpec and Opal::RSpec test suites', default: true
      option :autoloader, type: :boolean, desc: 'Include autoloader', default: true
      def project(directory_name)
        Gamefic::Sdk::Scaffold.build 'project', directory_name, **options
        puts "Gamefic project initialized at #{File.realpath(directory_name)}"
      end

      desc 'library DIRECTORY_NAME', 'Create a new library in DIRECTORY_NAME'
      def library(directory_name)
        Gamefic::Sdk::Scaffold.build 'library', directory_name
        puts "Gamefic library initialized at #{FIle.realpath(directory_name)}"
      end
    end
  end
end

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

      desc 'diagram TYPE', 'Get diagram data'
      long_desc %(
        SDK "diagrams" are datasets that can be used in analysis tools and
        graphical data representations. The dataset is provided in JSON
        format.

        The diagram types are entities, rooms, actions, verbs, syntaxes, and commands.
      )
      option :directory, type: :string, aliases: :d, desc: 'The project directory', default: '.'
      def diagram type
        main = Pathname.new(options[:directory]).join('main.rb').realpath.to_s
        require_relative main
        plot = Gamefic::Plot.new
        diagram = Gamefic::Sdk::Diagram.new(plot)
        puts diagram.get(type).to_json
      end
    end
  end
end

require 'thor'

module Gamefic
  module Sdk
    class Shell < Thor
      map %w[--version -v] => :version
      map [:create, :new] => :init

      desc "--version, -v", "Print the version"
      def version
        puts "gamefic-sdk #{Gamefic::Sdk::VERSION}"
        puts "gamefic #{Gamefic::VERSION}"
      end

      desc 'init DIRECTORY_NAME', 'Create a new project in DIRECTORY_NAME'
      option :gem, type: :boolean, aliases: [:g, :library, :rubygem], desc: 'Make a gem project'
      def init(directory_name)
        scaffold = options[:gem] ? 'library' : 'project'
        Gamefic::Sdk::Scaffold.build scaffold, directory_name
        puts "Gamefic project initialized at #{File.realpath(directory_name)}"
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

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

        The diagram types are rooms, commands, entities, actions, and commands.
      )
      option :directory, type: :string, aliases: :d, desc: 'The project directory', default: '.'
      def diagram type
        config = Gamefic::Sdk::Config.load(options[:directory])
        #if config.auto_import?
        #  Shell.start ['import', '.', '--quiet']
        #end
        paths = [config.script_path, config.import_path] + config.library_paths
        plot = Gamefic::Sdk::DebugPlot.new Gamefic::Plot::Source.new(*paths)
        plot.script 'main'
        diagram = Gamefic::Sdk::Diagram.new(plot)
        if type == 'rooms'
          puts diagram.rooms.values.to_json
        elsif type == 'actions'
          puts plot.action_info.to_json
        elsif type == 'entities'
          puts plot.entity_info.to_json
        elsif type == 'commands'
          puts({
            actions: plot.action_info,
            syntaxes: plot.syntaxes.map{|s| {template: s.template, command: s.command}},
            verbs: plot.verbs
          }.to_json)
        end
      end
    end
  end
end

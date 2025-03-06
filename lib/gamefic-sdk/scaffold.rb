require 'bundler'
require 'erb'
require 'fileutils'
require 'ostruct'
require 'pathname'
require 'securerandom'
require 'shellwords'

module Gamefic
  module Sdk
    module Scaffold
      class Binder < OpenStruct
        def camelcase string
          string.split(/[_\s\-]+/).collect(&:capitalize).join
        end

        def snake_case string
          string.split(/[_\s\-]+/).collect(&:downcase).join('_')
        end

        def get_binding
          binding
        end

        def render_autoloader
          'Gamefic::Autoload.setup(__dir__)'
        end
      end

      module_function

      def render(file, data)
        template = File.read(file)
        erb = ERB.new(template, trim_mode: '-')
        erb.result(data.get_binding)
      end

      def custom_copy origin, destination, data
        FileUtils.mkdir_p File.dirname(destination)
        if origin.end_with?('.gf.erb')
          content = render(origin, data)
          return if content.empty?

          File.write destination[0..-8], content
        else
          FileUtils.cp_r origin, destination
        end
      end

      def build name, destination, **opts
        dir = File.join(SCAFFOLDS_PATH, name)
        raise LoadError, "Scaffold `#{name}` does not exist" unless File.directory?(dir)

        path = Pathname.new('.').join(destination).realdirpath
        data = Binder.new(name: File.basename(path), **opts)
        files = Dir.glob(File.join(dir, '**', '*'), File::FNM_DOTMATCH).select { |entry| File.file?(entry) }
        map = {}
        files.each do |file|
          next if file.include?('/spec') && !opts[:specs]

          rename = File.join(File.dirname(file), File.basename(file)).gsub('__name__', data.snake_case(data.name))
          dst = File.join(destination, rename[dir.length..-1])
          raise "Gamefic generation would overwrite existing file #{rename}" if File.file?(dst)

          map[file] = dst
        end
        map.each_pair { |src, dst| custom_copy src, dst, data }
        Bundler.with_unbundled_env do
          Dir.chdir(path) { system 'bundle install' }
        end
      end
    end
  end
end

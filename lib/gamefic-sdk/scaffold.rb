require 'fileutils'
require 'erb'
require 'pathname'
require 'securerandom'

module Gamefic
  module Sdk
    module Scaffold
      class Binder < OpenStruct
        def get_binding
          binding()
        end
      end

      module_function

      def render(file, data)
        template = File.read(file)
        erb = ERB.new(template)
        erb.result(data.get_binding)
      end

      def custom_copy origin, destination, data
        FileUtils.mkdir_p File.dirname(destination)
        if destination.end_with?('.gf.erb')
          File.write destination[0..-8], render(origin, data)
        else
          FileUtils.cp_r origin, destination
        end
      end

      def build name, destination
        dir = File.join(SCAFFOLDS_PATH, name)
        raise LoadError, "Scaffold `#{name}` does not exist" unless File.directory?(dir)
        path = Pathname.new('.').join(destination).realdirpath
        data = Binder.new(name: File.basename(path))
        files = Dir.glob(File.join(dir, '**', '*'), File::FNM_DOTMATCH).select { |entry| File.file?(entry) }
        map = {}
        files.each do |file|
          rename = File.join(File.dirname(file), File.basename(file).gsub('__name__', data.name))
          dst = File.join(destination, rename[dir.length..-1])
          if File.file?(dst)
            raise RuntimeError, "Gamefic generation would overwrite existing file #{rename}"
          else
            map[file] = dst
          end
        end
        map.each_pair { |src, dst| custom_copy src, dst, data }
      end
    end
  end
end

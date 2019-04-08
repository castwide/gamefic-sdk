require 'gamefic-tty'
require 'tmpdir'
require 'zlib'
require 'fileutils'
require 'base64'

module Gamefic
  module Sdk
    module Tasks
      module Ruby
        def self.run
          load 'main.rb'
          Gamefic::Tty::Engine.run
        end

        def self.build
          current = $LOADED_FEATURES.clone
          gf_spec = Gem::Specification.find_by_name('gamefic')
          gf_tty_spec = Gem::Specification.find_by_name('gamefic-tty')
          load 'main.rb'
          loaded = ($LOADED_FEATURES - current)
          exports = {}
          exports.merge! append_gem('gamefic')
          exports.merge! append_gem('gamefic-tty')
          loaded.each do |path|
            exports.merge! relativize(path)
          end
          exports['main.rb'] = Pathname.new('.').join('main.rb').realpath.to_s
          files = {}
          exports.each_pair do |rel, full|
            files[rel] = Base64.encode64(Zlib::Deflate.deflate(File.read(full)))
          end
          program = program_code(files)
          FileUtils.mkdir_p File.join('builds', 'ruby')
          File.write(File.join('builds', 'ruby', 'game.rb'), program)
        end

        class << self
          private

          def append_gem name
            result = {}
            # @type [Gem::Specification]
            spec = Gem::Specification.find_by_name(name)
            spec.lib_files.each do |path|
              full = File.join(spec.full_gem_path, path)
              raise LoadError, "Unable to package gem file `#{path}`" unless File.file?(full)
              rel = full.sub(/^(#{spec.load_paths.join('|')})\//, '')
              result[rel] = full
            end
            result
          end

          def relativize path
            local = Pathname.new('.').realpath.to_s
            return path[local.length+1..-1] if path.start_with?(local)
            # @param spec [Gem::Specification]
            Gem::Specification.each do |spec|
              spec.load_paths.each do |lib_path|
                return { path[lib_path.length+1..-1] => path } if path.start_with?(lib_path)
              end
            end
            raise LoadError, "Unable to package loaded path `#{path}`"
          end

          # @param zips [Hash]
          # @return [String]
          def program_code(zips)
            %(#!/usr/bin/env ruby

zips = #{zips.inspect}

require 'tmpdir'
require 'fileutils'
require 'zlib'
require 'base64'

puts 'Loading...'
Dir.mktmpdir do |tmp|
  zips.each_pair do |file, code|
    FileUtils.mkdir_p File.join(tmp, 'lib', File.dirname(file))
    File.write(File.join(tmp, 'lib', file), Zlib::Inflate.inflate(Base64.decode64(code)))
  end
  $LOAD_PATH.unshift File.join(tmp, 'lib')
  require 'gamefic'
  require 'gamefic-tty'
  require 'main'
  puts "\n"
  Gamefic::Tty::Engine.run
end
)
          end
        end
      end
    end
  end
end

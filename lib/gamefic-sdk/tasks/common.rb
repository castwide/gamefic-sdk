# frozen_string_literal: true

require 'pathname'
require 'yaml'

module Gamefic
  module Sdk
    module Tasks
      # Common methods for Rake tasks.
      #
      module Common
        attr_reader :directory

        def initialize directory = '.'
          @directory = directory
        end

        def absolute_path
          @absolute_path ||= Pathname.new(directory).realpath.to_s
        end

        def config
          @config ||= YAML.load_file(File.join(absolute_path, 'config.yml'), symbolize_names: true)
        end

        def plot_class
          string_to_constant(config[:plot_class])
        end

        def string_to_constant string
          space = Object
          string.split('::').each do |part|
            space = space.const_get(part)
          end
          space
        end
      end
    end
  end
end

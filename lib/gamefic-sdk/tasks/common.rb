require 'pathname'

module Gamefic
  module Sdk
    module Tasks
      module Common
        attr_reader :directory

        def initialize directory = '.'
          @directory = directory
        end

        def absolute_path
          @absolute_path ||= Pathname.new(directory).realpath.to_s
        end
      end
    end
  end
end

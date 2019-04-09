module Gamefic
  module Sdk
    module Tasks
      class Web
        include Common

        def self.generate directory = '.'
          new(directory).generate
        end

        def self.run directory = '.'
          new(directory).run
        end

        def self.serve directory = '.'
          new(directory).serve
        end

        def self.build directory = '.'
          new(directory).build
        end

        def generate
          Dir.chdir absolute_path do
            nv = `npm -v`.strip
            puts "Node version #{nv} detected. Preparing the web app..."
            Gamefic::Sdk::Scaffold.build 'react', '.'
            puts 'The web app scaffold is ready.'
            puts 'Run `npm install` to download the dependencies.'
          end
        rescue Errno::ENOENT => e
          STDERR.puts "#{e.class}: #{e.message}"
          STDERR.puts "Web app generation requires Node (https://nodejs.org)."
        end

        def run
          check_for_web_build
        end

        def serve
          check_for_web_build
        end

        def build
          check_for_web_build
          Dir.chdir absolute_path do
            exec 'npm install && npm run build'
          end
        rescue Errno::ENOENT => e
          STDERR.puts "#{e.class}: #{e.message}"
          STDERR.puts "Web app building requires Node (https://nodejs.org)."
        end

        private

        def web_build_exists?
          File.exist?(File.join(absolute_path, 'package.json'))
        end

        def check_for_web_build
          return if web_build_exists?
          puts 'This project does not appear to be configured for web builds.'
          puts 'Try running `rake web:generate` first.' if Rake::Task.task_defined?('web:generate')
          raise LoadError, 'package.json not found'
        end
      end
    end
  end
end

module Gamefic
  module Sdk
    module Tasks
      module Web
        def self.generate
          nv = `npm -v`.strip
          puts "Node version #{nv} detected. Preparing the web app..."
          Gamefic::Sdk::Scaffold.build 'react', '.'
          puts 'The web app scaffold is ready.'
          puts 'Run `npm install` to download the dependencies.'
        rescue Errno::ENOENT => e
          STDERR.puts "#{e.class}: #{e.message}"
          STDERR.puts "Web app generation requires Node (https://nodejs.org)."
        end

        def self.run
          check_for_web_build
        end

        def self.serve
          check_for_web_build
        end

        def self.build
          check_for_web_build
          exec 'npm install && npm run build'
        rescue Errno::ENOENT => e
          STDERR.puts "#{e.class}: #{e.message}"
          STDERR.puts "Web app building requires Node (https://nodejs.org)."
        end

        class << self
          private

          def web_build_exists?
            File.exist?('package.json')
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
end

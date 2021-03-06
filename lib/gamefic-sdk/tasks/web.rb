require 'listen'

module Gamefic
  module Sdk
    module Tasks
      # Tasks for running and building web apps.
      #
      class Web
        include Common

        # Generate a web app using NPM.
        #
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

        # Run the web app in a server.
        #
        def run
          check_for_web_build
          build_development
          listener = Listen.to(File.join(absolute_path, 'web')) do |_mod, _add, _rem|
            build_development
          end
          listener.start
          # @todo Get the public folder from a config?
          Gamefic::Sdk::Server.run! source_dir: absolute_path, public_folder: File.join(absolute_path, 'builds', 'web', 'development')
        end

        # Build a distributable web app using NPM.
        #
        def build
          check_for_web_build
          Dir.chdir absolute_path do
            pid = Process.spawn 'npm run build'
            Process.wait pid
          end
        rescue Errno::ENOENT => e
          STDERR.puts "#{e.class}: #{e.message}"
          STDERR.puts "Web app building requires Node (https://nodejs.org)."
        end

        private

        # True if a web build has been generated for the current project.
        #
        # @return [Boolean]
        def web_build_exists?
          File.exist?(File.join(absolute_path, 'package.json'))
        end

        # Check if a web build exists.
        #
        # @raise [LoadError] if a web build is not available.
        # @return [void]
        def check_for_web_build
          return if web_build_exists?
          puts 'This project does not appear to be configured for web builds.'
          puts 'Try running `rake web:generate` first.' if Rake::Task.task_defined?('web:generate')
          raise LoadError, 'package.json not found'
        end

        def build_development
          Dir.chdir absolute_path do
            pid = Process.spawn('npm run develop')
            Process.wait pid
          end
        end
      end
    end
  end
end

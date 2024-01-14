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
          puts "Node version #{check_for_npm} detected. Preparing the web app..."
          web_path = File.join(absolute_path, 'web')
          FileUtils.mkdir_p web_path
          Dir.chdir web_path do
            name = File.basename(absolute_path)
            system 'npx', 'react-gamefic', '--name', name, '--class', config[:plot_class]
            puts 'The web app is ready.'
            puts 'Run `rake web:run` to start the app in dev mode.'
          end
        end

        # Run the web app in a server.
        #
        def run
          check_for_web_build
          Dir.chdir File.join(absolute_path, 'web') do
            system 'npm start'
          end
        end

        # Build a distributable web app using NPM.
        #
        def build
          check_for_web_build
          Dir.chdir File.join(absolute_path, 'web') do
            system 'npm run build'
          end
        rescue Errno::ENOENT => e
          warn "#{e.class}: #{e.message}"
          warn 'Web app building requires Node (https://nodejs.org).'
        end

        private

        # True if a web build has been generated for the current project.
        #
        # @return [Boolean]
        def web_build_exists?
          File.exist?(File.join(absolute_path, 'web', 'package.json'))
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

        def check_for_npm
          `npm -v`.strip
        rescue Errno::ENOENT => e
          warn "#{e.class}: #{e.message}"
          warn 'Web app generation requires Node (https://nodejs.org).'
          raise
        end
      end
    end
  end
end

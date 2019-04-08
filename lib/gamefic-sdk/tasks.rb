require 'rubygems'
require 'gamefic-sdk'
require 'rake'

module Gamefic::Sdk::Tasks
  autoload :Ruby, 'gamefic-sdk/tasks/ruby'
  autoload :Web,  'gamefic-sdk/tasks/web'

  module_function

  def define_all
    define_task 'ruby:run', 'Run a Ruby CLI app' do
      Gamefic::Sdk::Tasks::Ruby.run
    end

    define_task 'ruby:build', 'Build a distributable CLI app' do
      Gamefic::Sdk::Tasks::Ruby.build
    end

    define_task 'web:generate', 'Generate a web app' do
      Gamefic::Sdk::Tasks::Web.generate
    end

    define_task 'web:run', 'Run a standalone web app' do
      Gamefic::Sdk::Tasks::Web.run
    end

    define_task 'web:serve', 'Run the app in a web server' do
      Gamefic::Sdk::Tasks::Web.serve
    end

    define_task 'web:build', 'Build a distributable web app?' do
      Gamefic::Sdk::Tasks::Web.build
    end
  end

  def define_task name, desc, &block
    return if Rake::Task.task_defined?(name)
    # @type [Rake::Task]
    task = Rake::Task.define_task(name, &block)
    task.add_description desc
  end
end

Gamefic::Sdk::Tasks.define_all

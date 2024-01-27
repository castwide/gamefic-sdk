require 'rubygems'
require 'gamefic-sdk'
require 'rake'

module Gamefic::Sdk::Tasks
  autoload :Common, 'gamefic-sdk/tasks/common'
  autoload :Ruby,   'gamefic-sdk/tasks/ruby'
  autoload :Web,    'gamefic-sdk/tasks/web'

  module_function

  def define_all
    define_task 'ruby:run', 'Run a Ruby CLI app' do
      Ruby.new.run
    end

    define_task 'ruby:build', 'Build a distributable CLI app' do
      Ruby.new.build
    end

    define_task 'web:generate', 'Generate a web app' do
      Web.new.generate
    end

    define_task 'web:run', 'Run a standalone web app' do
      Web.new.run
    end

    define_task 'web:build', 'Build a distributable web app' do
      Web.new.build
    end
  end

  def define_task name, desc, &block
    return if Rake::Task.task_defined?(name)

    # @type [Rake::Task]
    task = Rake::Task.define_task(name, &block)
    task.add_description desc
  end
end

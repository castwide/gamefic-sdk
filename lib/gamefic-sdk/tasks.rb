require 'bundler'
require 'rubygems'
require 'gamefic-sdk'
require 'rake'
require 'rspec/core/rake_task'
require 'opal/rspec/rake_task'

module Gamefic::Sdk::Tasks
  autoload :Common, 'gamefic-sdk/tasks/common'
  autoload :Ruby,   'gamefic-sdk/tasks/ruby'
  autoload :Web,    'gamefic-sdk/tasks/web'

  module_function

  def define_all_tasks
    define_build_tasks
    define_spec_tasks
  end
  alias define_all define_all_tasks

  def define_build_tasks
    define_task 'ruby:run', 'Run a Ruby CLI app' do
      Ruby.new.run
    end

    define_task 'ruby:build', 'Build a distributable CLI app' do
      Ruby.new.build
    end

    Rake::Task.define_task('web:generate', [:version]) { |_, args| Web.new.generate(args[:version]) }
              .tap { |task| task.add_description 'Generate a web app' }

    define_task 'web:run', 'Run a standalone web app' do
      Web.new.run
    end

    define_task 'web:build', 'Build a distributable web app' do
      Web.new.build
    end

    define_task 'web:autoload', 'Generate autoload.rb for Opal' do
      Web.new.autoload
    end
  end

  def define_spec_tasks
    RSpec::Core::RakeTask.new(:spec)

    Opal::RSpec::RakeTask.new(:opal) do |_, config|
      Bundler.definition
             .dependencies_for([:default])
             .each { |dep| Opal.use_gem dep.name }
      Opal.append_path '.'
      Opal.append_path File.join('.', 'lib')
      config.pattern = 'spec/**/*_spec.rb'
      config.requires = ['spec/opal_helper']
    end

    Rake::Task.define_task(:opal).prerequisite_tasks.push('web:autoload')
  end

  def define_task(name, desc, &block)
    return if Rake::Task.task_defined?(name)

    # @type [Rake::Task]
    task = Rake::Task.define_task(name, &block)
    task.add_description desc
  end
end

require 'sinatra/base'
require 'yaml'

module Gamefic
  module Sdk
    class Server < Sinatra::Base
      set :port, 4342
      set :server, :webrick

      get '/' do
        File.read File.join(settings.public_folder, 'index.html')
      end

      post '/start' do
        content_type :json
        start_plot
        @@character.output.to_json
      end

      post '/receive' do
        content_type :json
        @@character.queue.push params['command']
        {}.to_json
      end

      post '/update' do
        content_type :json
        @@plot.update
        @@plot.ready
        @@character.output.to_json
      end

      get '/snapshot' do
        content_type :json
        @@plot.save.to_json
      end

      post '/restore' do
        content_type :json
        start_plot
        # The snapshot needs to be received as a JSON string because of issues
        # with IndifferentHash malforming arrays.
        snapshot = JSON.parse(params['snapshot'])
        @@plot.restore snapshot
        @@character.cue @@plot.default_scene
        @@plot.update
        @@plot.ready
        @@character.output.to_json
      end

      def start_plot
        reset_features
        load File.join(settings.source_dir, 'main.rb')
        @@plot = Gamefic::Plot.new
        @@character = @@plot.get_player_character
        @@plot.introduce @@character
        @@plot.ready
      end

      def reset_features
        @@old_features ||= $LOADED_FEATURES.clone
        @@old_constants ||= Object.constants(false)
        $LOADED_FEATURES.keep_if { |e| @@old_features.include?(e) }
        Object.constants(false).each do |const|
          Object.send(:remove_const, const) unless @@old_constants.include?(const)
        end
        Gamefic::Plot.blocks.clear
      end
    end
  end
end

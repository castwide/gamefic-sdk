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
        reset_features
        load File.join(settings.source_dir, 'main.rb')
        @@plot = Gamefic::Plot.new
        @@character = @@plot.get_player_character
        @@plot.introduce @@character
        @@plot.ready
        @@character.state.to_json
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
        # @@character.state.merge(input: params['command'], continued: @@character.queue.any?).to_json
        @@character.state.to_json
      end

      post '/restore' do
        content_type :json
        snapshot = JSON.parse(params['snapshot'], symbolize_names: true)
        @@plot.restore snapshot
        @@character.cue @@plot.default_scene
        @@plot.update
        @@plot.ready
        @@character.state.to_json
      end

      def reset_features
        @@old_features ||= $LOADED_FEATURES.clone
        $LOADED_FEATURES.keep_if { |e| @@old_features.include?(e) }
        Gamefic::Plot.blocks.clear
      end

      class << self
        # def run!
        #   start_browser if settings.browser
        #   super
        # end

        # def start_browser
        #   Thread.new {
        #     sleep 1 until Server.running?
        #     `start http://localhost:#{settings.port}`
        #   }
        # end
      end
    end
  end
end

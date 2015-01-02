require './lib/game.rb'
require 'sinatra'

set :views, proc { File.join(root, '..', 'views') }
set :public_dir, proc { File.join(root, '..', 'public') }
set :session_secret, ENV['BOWLING_SECRET']
set :logging, false

enable :sessions

get '/' do
  erb :index
end

post '/roll' do
  session[:game].player_roll(params[:num_of_pins].to_i)
end

post '/new-game' do
  session[:num_of_players] = params[:num_of_players].to_i
  session[:game] = Game.new(session[:num_of_players])
end

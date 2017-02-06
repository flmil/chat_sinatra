require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra'
require 'sinatra/json'
require './models.rb'
require 'open-uri'
require 'time'
require './models'

enable :sessions

helpers do
	def current_user
		User.find_by(id: session[:user])
	end
end

get '/' do
	@namerooms = Room.order('id DESC').all
	erb :index 
end

get '/signin' do
	erb :signin
end

get '/signup' do
	erb :signup
end

post '/signup' do
	@user = User.create(
		mail:params[:mail],
		name:params[:name],
		idsearch:params[:idsearch],
		password:params[:password],
		password_confirmation:params[:password_confmation],
	)
	if @user.persisted?
		session[:user] = @user.id
	end
	redirect '/'
end

post '/signin' do
	user = User.find_by(mail: params[:mail])
	if user && user.authenticate(params[:password])
		session[:user] = user.id
	end

	redirect '/'
end

get '/signout' do
	session[:user] = nil
	redirect '/'
end

get  '/room/:room_id' do
	@namerooms = Room.find_by(id: params[:room_id])
	erb :room
end

post '/create_room' do
	Room.create({
		roomname: params[:roomname]
	})

	redirect '/'
end

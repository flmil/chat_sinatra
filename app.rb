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
	@message = Message.order('id DESC').all
	erb :room
end

post '/create_room' do
	Room.create({
		roomname: params[:roomname]
	})

	redirect '/'
end

post '/new/message' do
	@namerooms = Room.find_by(id: params[:room_id])
	session[:user]
	Message.create({
		body: params[:body],
		username: User.find(session[:user]).name,
		#name_id: User.find(session[:user]).id,
		#room_id: Room.find_by(id: params[:room_id])
	})
	@roomid_new = Room.find_by(id: params[:room_id])

	redirect '/room/1'
end

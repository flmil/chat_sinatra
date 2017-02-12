require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra'
require 'sinatra/json'
require './models.rb'
require 'open-uri'
require 'time'
require './models'
#require 'sinatra-websocket'

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
	@user = current_user
	@namerooms = Room.find_by(id: params[:room_id])
	@message = @namerooms.messages

	erb :room
end

post '/create_room' do
	room = Room.create({
		roomname: params[:roomname],
	})
	Acticletag.create({
		room_id: room,
		user_id: session[:user]
	})
	redirect '/'
end

post '/new/message' do
	p params[:room_id]
	Message.create({
		body: params[:body],
		room_id: params[:room_id],
		username: User.find(session[:user]).name
		#username: User.find(session[:user]).id
	})	
	redirect "/room/#{params[:room_id]}"
end

get '/edit/:user_id' do
	@user = current_user
	erb :edit
end

get '/edit_mail/:user_id' do
	@user = current_user
	erb :edit_mail
end	

get '/edit_name/:user_id' do
	@user = current_user
	erb :edit_name
end	

get '/edit_password/:user_id' do
	@user = current_user
	erb :edit_password
end	

post '/renew_mail/:user_id' do
	cercurrent_user.update({
		mail: params[:mail]
	})
	redirect '/'
end

post '/renew_name/:user_id' do
	current_user.update({
		name: params[:name]
	})
	redirect '/'
end

get '/list_user' do
	@users = User.all
	@friends = current_user.friends
	erb :list_user
end

post '/friend/:user_id' do
	# 1. 友達になりたいユーザを取り出す
	target_user = User.find(params[:user_id])
	# 2. current_userのfriendsに1.のユーザを追加する
	current_user.friends << target_user
	# 3. 1.のユーザのfriendsにcurrent_userを追加する
	target_user.friends << current_user

	redirect '/list_user'
end

get  '/oneroom/:user_id' do
	@user = current_user
	# TODO:
	# user_idとcurrent_user.idからRoomを探す
	# →見つかればそれ使う
	# なければRoom作る
	@namerooms = Room.find_by(id: params[:user_id])
	@message = @namerooms.messages

	erb :room
end


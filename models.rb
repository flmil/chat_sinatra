require 'bundler/setup'
Bundler.require

if development?
	ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

#unless ENV['RACK_ENV'] == 'production'
#    ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
#end

class User < ActiveRecord::Base
	has_secure_password
	validates :name,
		presence: true,
		format: { with: /\A\w+\z/ }
	validates :password,
		length: { in: 3..25 }
	has_many :acticletag
	belongs_to :massage
end

class Room < ActiveRecord::Base
	has_many :acticletag
	belongs_to :message
end
class Message < ActiveRecord::Base
	has_many :room
	has_many :user
end
class Acticletag < ActiveRecord::Base
	belongs_to :user
	belongs_to :room
end

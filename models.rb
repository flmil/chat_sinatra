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

	validates :mail,
		presence: true,
		format: {with: /.+@./ } 

	validates :password, confirmation: true,
		unless: Proc.new { |a| a.password.blank? }
	#		format: {with: /.+@.+/ }

	has_many :acticletags
	has_many :rooms, through: :acticletags
	has_many :relationships, dependent:   :destroy
	has_many :friends, through: :relationships, source: :friend
end

class Room < ActiveRecord::Base
	has_many :acticletag
	has_many :users, through: :acticletags
	has_many :messages
end

class Message < ActiveRecord::Base
	belongs_to :room
end

class Acticletag < ActiveRecord::Base
	belongs_to :user
	belongs_to :room
end

class Relationship < ActiveRecord::Base
	validates :user_id, :uniqueness => {:scope => :friend_id}
	belongs_to :user, class_name:"User"
	belongs_to :friend ,class_name:"User"
end

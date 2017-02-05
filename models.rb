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

end

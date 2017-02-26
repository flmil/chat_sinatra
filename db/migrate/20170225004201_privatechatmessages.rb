class Privatechatmessages < ActiveRecord::Migration
	def change
		create_table :privatechatmessages do |t|
			t.string :body
			t.string :username
			t.integer :friend_id

			t.timestamps null: false
		end
	end
end

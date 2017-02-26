class Privatechatmembers < ActiveRecord::Migration
	def change
		create_table :privatechatmembers do |t|
			t.integer :user_id
			t.integer :friend_id
			t.integer :private_room_id

			t.timestamps null: false
		end
	end
end

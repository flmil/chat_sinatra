class Privatechatrooms < ActiveRecord::Migration
	def change
		create_table :privatechatrooms do |t|

			t.timestamps null: false
		end
	end
end

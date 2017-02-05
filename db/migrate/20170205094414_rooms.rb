class Rooms < ActiveRecord::Migration
  def change
		create_table :rooms do |t|
			t.integer :user_id
			t.integer :massage_id

			t.timestamps null: false
		end
  end
end

class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :email
      t.integer :restaurant_id
      t.integer :role_id

      t.timestamps null: false
    end
  end
end

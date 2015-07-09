class AddRestaurantIdToItems < ActiveRecord::Migration
  def change
    add_reference :items, :restaurant, index: true
    add_foreign_key :items, :restaurants
  end
end

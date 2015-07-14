class AddRestaurantIdToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :restaurant, index: true
    add_foreign_key :orders, :restaurants
  end
end

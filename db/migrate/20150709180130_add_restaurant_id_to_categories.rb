class AddRestaurantIdToCategories < ActiveRecord::Migration
  def change
    add_reference :categories, :restaurant, index: true
    add_foreign_key :categories, :restaurants
  end
end

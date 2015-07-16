class CreateUserRestaurantRoles < ActiveRecord::Migration
  def change
    create_table :user_restaurant_roles do |t|
      t.references :user, index: true
      t.references :role, index: true
      t.references :restaurant, index: true

      t.timestamps null: false
    end
    add_foreign_key :user_restaurant_roles, :users
    add_foreign_key :user_restaurant_roles, :roles
    add_foreign_key :user_restaurant_roles, :restaurants
  end
end

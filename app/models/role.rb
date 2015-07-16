class Role < ActiveRecord::Base
  has_many :user_restaurant_roles
  belongs_to :restaurant
end

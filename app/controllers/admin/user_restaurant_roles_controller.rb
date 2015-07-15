class Admin::UserRestaurantRolesController < ApplicationController
  before_action :set_restaurant

  def index
    @staff = @restaurant.users
  end

  def new
    @staff_member = UserRestaurantRole.new
    @roles = Role.all
  end

  def create
   @user = User.find_by(email: params[:email])
   binding.pry
     params[:user_role][:user_id] = user.id
     user_role = UserRestaurantRole.create(user_id: @user.id, role_id: role.id, restaurant: @restau )
     
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
  end

  def role_params
    params.require(:user_restaurant_roles).permit(:role_id, :user_id, :restaurant_id)
  end
end

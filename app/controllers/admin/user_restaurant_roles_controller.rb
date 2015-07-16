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
   user_role = UserRestaurantRole.new(user_id: @user.id, role_id: params[:roles].to_i, restaurant_id: @restaurant.id )
     if user_role.save
       flash[:message] = "You have successfully added #{@user.full_name} as a '#{@user.roles.last.name}'"
       redirect_to admin_restaurant_user_restaurant_roles_path(@restaurant)
     else
       flash[:notice] = "THis doesn't work bitch"
       render :new
     end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
  end

  def role_params
    params.require(:user_restaurant_roles).permit(:role_id, :user_id, :restaurant_id)
  end
end

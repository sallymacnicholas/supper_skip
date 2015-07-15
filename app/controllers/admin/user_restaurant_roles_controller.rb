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
   user_role = UserRestaurantRole.create(user_id: @user.id, role_id: params[:roles].to_i, restaurant_id: @restaurant.id )
   flash[:message] = "You suck"
   redirect_to admin_restaurant_user_restaurant_roles_path(@restaurant)
    #  if user_role.save
    #    flash[:message] = "You have successfully added #{user.name} as '#{user.user_roles.map(&:role).last.name}'"
    #    redirect_to admin_restaurant_user_restaurant_roles_path(@restaurant)
    #  else
    #    flash[:notice] = "THis doesn't work bitch"
    #    render :new
    #  end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
  end

  def role_params
    params.require(:user_restaurant_roles).permit(:role_id, :user_id, :restaurant_id)
  end
end

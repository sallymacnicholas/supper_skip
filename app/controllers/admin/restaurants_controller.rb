class Admin::RestaurantsController < ApplicationController
  before_action :current_restaurant
  before_action :authorize_owner
  
  def show
    if params[:status].nil? || params[:status] == "all"
      @orders = current_restaurant.orders
    else
      @orders = current_restaurant.orders.where(status: params[:status])
    end
  end
  
  def edit
  end
  
  def update
    @restaurant.update(restaurant_params)
    if @restaurant.save!
      redirect_to restaurant_path(@restaurant)
    else
      flash[:warning].now = "There was a problem updating your restaurant"
    end
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :slug)
  end
  
  def current_restaurant
    @restaurant = current_user.restaurant
  end
  
  def authorize_owner
    unless current_restaurant == Restaurant.find_by_slug(params[:slug])
      redirect_to root_path
    end
  end
end

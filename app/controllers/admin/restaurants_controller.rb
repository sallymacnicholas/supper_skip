class Admin::RestaurantsController < ApplicationController
  before_action :authorize_owner
  
  def show
    @restaurant = current_restaurant
  end
  
  def edit
    @restaurant = current_restaurant
  end
  
  def update
    restaurant = current_restaurant
    restaurant.update(restaurant_params)
    if restaurant.save!
      redirect_to restaurant_path(restaurant)
    else
      flash[:warning].now = "There was a problem updating your restaurant"
    end
  end
  
private
  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :slug)
  end
  
  def current_restaurant
    current_user.restaurants.find_by(slug: params[:slug])
  end
  
  def authorize_owner
    unless current_restaurant
      redirect_to root_path
    end
  end
end

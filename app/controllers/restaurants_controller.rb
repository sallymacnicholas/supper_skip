class RestaurantsController < ApplicationController
  def new
    @restaurant = Restaurant.new
  end

  def show
    @restaurant = current_user.restaurants.find(params[:id])
  end

  def create
    restaurant = current_user.restaurants.new(restaurant_params)
    if restaurant.save!
      flash[:success] = "Restaurant successfully created! Welcome."
      redirect_to restaurant_path(restaurant)
    else
      flash[:errors] = restaurant.errors.full_messages.join(", ")
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :slug)
  end

end

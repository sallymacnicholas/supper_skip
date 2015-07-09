class RestaurantsController < ApplicationController
  #In this controller, find restaurants by slug
  
  def new
    @restaurant = Restaurant.new
  end

  def show
    @restaurant = Restaurant.find_by_slug(params[:slug])
    @categories = @restaurant.categories
  end

  def create
    restaurant = Restaurant.new(restaurant_params)
    restaurant.user_id = current_user.id
    if restaurant.save
      flash[:success] = "Restaurant successfully created! Welcome."
      redirect_to restaurant
    else
      flash[:errors] = restaurant.errors.full_messages.join(", ")
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :slug)
  end

end

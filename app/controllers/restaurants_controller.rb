class RestaurantsController < ApplicationController
  def new
    @restaurant = Restaurant.new
  end

  # def show
  #   @restaurant = current_user.restaurants.find(params[:id])
  # end

  def show
    @restaurant = Restaurant.find_by_slug(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @restaurant }
    end
    return restaurant_url
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

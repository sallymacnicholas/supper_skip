class Admin::RestaurantItemsController < ItemsController
  def index
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
    @items = @restaurant.items
  end
  
  def new
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
    @item = Item.new
  end
end

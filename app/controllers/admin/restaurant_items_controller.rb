class Admin::RestaurantItemsController < ItemsController
  def index
    @items = Restaurant.find_by_slug(params[:restaurant_slug]).items
  end
end

class Admin::RestaurantItemsController < ItemsController
  include Admin::RestaurantItemHelper
  
  def index
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
  end
  
  def new
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
    @item = Item.new
  end
  
  def create
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
    @item = Item.new(item_params)
    add_categories(params[:item][:categories])
    redirect_to admin_restaurant_items_path(@restaurant)
    @restaurant.items << @item
  end
  
private
  
  def item_params
    params.require(:item).permit(:title,
                                 :description,
                                 :unit_price,
                                 :active,
                                 :image)
  end
end

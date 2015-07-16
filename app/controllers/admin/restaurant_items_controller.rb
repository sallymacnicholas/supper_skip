class Admin::RestaurantItemsController < ApplicationController
  include Admin::RestaurantItemHelper
  before_action :current_restaurant
  before_action :authorize_owner

  def index
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    add_categories(params[:item][:categories])
    redirect_to admin_restaurant_items_path(@restaurant)
    @restaurant.items << @item
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    update_categories(params[:item][:categories])
    @item.save!
    redirect_to admin_restaurant_items_path(@restaurant)
  end

private

  def item_params
    params.require(:item).permit(:title,
                                 :description,
                                 :unit_price,
                                 :active,
                                 :image)
  end

  def current_restaurant
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
  end

  def authorize_owner
    unless current_restaurant == Restaurant.find_by_slug(params[:restaurant_slug])
      redirect_to root_path
    end
  end
end

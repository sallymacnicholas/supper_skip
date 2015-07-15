class Admin::OrdersController < ApplicationController
  before_action :current_restaurant
  before_action :authorize_owner

  def filter
    if params[:status] == "all"
      @orders = current_restaurant.orders.all
    else
      @orders = current_restaurant.orders.where("status = ?", params[:status])
    end
    redirect_to admin_restaurant_path(slug: current_restaurant.slug, status: params[:status])
  end

  def update
    order = current_restaurant.orders.find(params[:id])
    order.update_attributes(status: params[:new_status])
    redirect_to admin_restaurant_path(slug: current_restaurant.slug, status: params[:status])
  end
  
  private

  def current_restaurant
    @restaurant = current_user.restaurant
  end

  def authorize_owner
    unless current_restaurant == Restaurant.find_by_slug(params[:restaurant_slug])
      redirect_to root_path
    end
  end
end

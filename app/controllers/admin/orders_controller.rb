class Admin::OrdersController < ApplicationController
  before_action :current_restaurant
  before_action :authorize_staff

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
    Restaurant.find_by_slug(params[:restaurant_slug])
  end

  def authorize_staff
    unless current_user.is_owner?(current_restaurant) || current_user.has_restaurant_role?(current_restaurant)
      redirect_to root_path
    end
  end
end

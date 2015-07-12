class Admin::RestaurantCategoriesController < ApplicationController
  def index
    @categories = Restaurant.find_by_slug(params[:restaurant_slug]).categories
  end
end

class Admin::RestaurantCategoriesController < ApplicationController
  before_action :current_restaurant
  before_action :find_category, only: [:edit, :update, :destroy]
  
  def index
  end

  def new
    @category = Category.new
  end
  
  def edit
  end
  
  def create
    category = Category.new(category_params)
    @restaurant.categories << category
    redirect_to admin_restaurant_categories_path(@restaurant)
  end

  def update
    @category.update(category_params)
    @category.save!
    redirect_to admin_restaurant_categories_path(@restaurant)
  end

  def destroy
    if can_delete?
      @category.destroy!
      flash[:notice] = "You deleted the #{@category.name} category."
      redirect_to admin_restaurant_categories_path(@restaurant)
    else
      flash[:warning] = "You cannot delete the #{@category.name} category, it still has items associated with it!"
      redirect_to admin_restaurant_categories_path(@restaurant)
    end
  end
  private
  
  def current_restaurant
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
  end
  
  def find_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
  
  def can_delete?
    @category.category_items.empty?
  end
end

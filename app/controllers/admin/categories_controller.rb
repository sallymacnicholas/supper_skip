class Admin::CategoriesController < ApplicationController
  before_action :authorize_owner

  def index
    @categories = Category.all
  end

  def edit
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create(category_params)
    redirect_to admin_categories_path
  end

  def update
    @category = Category.find(params[:id])
    @category.update(category_params)
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def current_restaurant
    @restaurant = current_user.restaurant
  end

  def authorize_owner
    unless current_restaurant == Restaurant.find_by_slug(params[:restaurant_slug])
      redirect_to root_path
    end
  end
end

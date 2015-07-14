class Admin::RestaurantCategoriesController < Admin::CategoriesController
  def index
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
  end

  def new
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
    @category = Category.new
  end

  def create
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
    @category = Category.new(category_params)
    redirect_to admin_restaurant_categories_path(@restaurant)
    @restaurant.categories << @category
  end

  def update
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
    @category = Category.find(params[:id])
    @category.update(category_params)
    @category.save!
    redirect_to admin_restaurant_categories_path(@restaurant)
  end

  def destroy
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_restaurant_categories_path(@restaurant)
  end
  private

  def category_params
    params.require(:category).permit(:name)
  end
end

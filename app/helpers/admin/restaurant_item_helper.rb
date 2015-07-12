module Admin::RestaurantItemHelper
  
  def add_categories(category_ids)
    @categories = category_ids.map do |category_id|
      Category.find_by(id: category_id)
    end
    @categories.compact.each do |category|
      @item.categories << category
    end
  end

  def update_categories(category_ids)
    @item.categories.clear
    add_categories(category_ids)
  end
end

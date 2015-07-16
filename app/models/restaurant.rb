class Restaurant < ActiveRecord::Base
  before_save :set_slug
  belongs_to :user
  has_many :categories
  has_many :items
  has_many :orders
  has_many :user_restaurant_roles
  has_many :users, through: :user_restaurant_roles
  has_many :roles, through: :user_restaurant_roles

  validates :name, presence: true,
                   uniqueness: true
  validates :slug, uniqueness: true
  validates :description, presence: true

  def set_slug
    if slug.nil? || slug == ""
      self.slug = name.parameterize
    else
      self.slug = slug.parameterize
    end
  end

  def to_param
    slug
  end

  def self.featured_restaurants
    all.sample(3)
  end
  
  def frequently_ordered_items
    Hash[frequency_of_items_sold.sort.reverse].values[0..2]
  end
  
  def all_order_items
    orders.flat_map {|order| order.order_items }
  end
  
  def frequency_of_items_sold
    all_order_items.each_with_object({}) do |order_item, items|
      if items[order_item.item]
        items[order_item.item] += order_item.quantity
      else
        items[order_item.item] = order_item.quantity
      end
    end.invert
  end
end

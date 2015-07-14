class Cart
  attr_accessor :cart_items

  def initialize(cart_items_hash = Hash.new)
    @cart_items = cart_items_hash || Hash.new
  end

  def empty?
    @cart_items.count == 0
  end

  def add_item(item_id)
    cart_items[item_id] ||= 0
    cart_items[item_id] += 1
  end

  def count
    cart_items.values.inject(0, :+)
  end

  def remove_item(item_id)
    cart_items.except!(item_id)
  end

  def clear
    @cart_items = Hash.new
  end
  
  def all_items
    cart_items.map { |item, quantity| [Item.find(item), quantity] }.to_h
  end
  
  def total_cost
    all_items.map { |item, quantity| item.unit_price }.sum
  end
  
  def items_by_restaurant
    all_items.group_by { |i, q| i.restaurant }
  end
end

require 'json'

module OrderCreator

  def self.execute_order(cart, user)
    transaction = create_user_transaction(cart, user)
    restaurant_orders = cart.items_by_restaurant
    restaurant_orders.each do |restaurant, items|
      Order.transaction do
        order = user.orders.create!(restaurant_id: restaurant.id)
        create_order_items(order, items)
        order.update_attributes(total_price: order.order_total)
        transaction.orders << order
      end
    end
  end

  def self.create_order_items(order, items)
    items.each do |item, quantity|
      order.order_items.create!(item_id: item.id,
                                quantity: quantity,
                                line_item_price: quantity * item.unit_price)
    end
  end
  
  def self.create_user_transaction(cart, user)
    order_cart = cart.cart_items.to_json
    UserTransaction.create!(order_total: cart.total_cost, cart: order_cart, user_id: user.id)
  end
end

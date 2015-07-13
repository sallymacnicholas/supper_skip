class OrdersController < ApplicationController
  include OrderCreator
  
  def new
    @order = Order.new
  end

  def create
    OrderCreator.execute_order(@cart, current_user)
    @cart.clear
    redirect_to user_order_path(current_user.most_recent_transaction)
  end
end

class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def index
    if current_user
      @orders = Order.where("user_id = ?", current_user.id)
    else
      redirect_to root_path
    end
  end

  def create
    @order = Order.create(user_id:     current_user.id,
                          status:      "ordered")
    @order.create_order_items(@cart)
    @order.update_attributes(total_price: @order.order_total)
    @cart.clear
    redirect_to order_path(@order)
  end
end


###When we get here, do not panic
  # For user orders and restaurant orders,
  # Create two separate tables
  # and an order_creator PORO with nested transactions for user orders and restaurant orders 

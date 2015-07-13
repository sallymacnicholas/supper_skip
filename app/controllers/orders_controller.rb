class OrdersController < ApplicationController
  include OrderCreator
  
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
    OrderCreator.execute_order(@cart, current_user)
    @cart.clear
    redirect_to user_order_path(current_user.most_recent_transaction)
  end
end

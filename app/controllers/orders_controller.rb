class OrdersController < ApplicationController
  include OrderCreator
  
  def new
    @order = Order.new
  end

  def create
    check_for_new_cart
    OrderCreator.execute_order(@cart, current_user)
    @cart.clear
    session[:cart] = {}
    redirect_to user_order_path(current_user.most_recent_transaction)
  end
  
  def destroy
    @order = Order.find(params[:id])
    if @order.cancel
      @order.save!
      flash[:notice] = "Your order has been successfully cancelled."
    else
      flash[:warning] = "Your order cannot be cancelled at this time."
    end
    redirect_to user_order_path(@order.user_transaction)
  end
  
  private
  
  def check_for_new_cart
    if params[:cart]
      @cart = Cart.new(params[:cart])
    end
  end
end

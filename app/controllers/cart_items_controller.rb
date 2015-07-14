class CartItemsController < ApplicationController
  after_action "save_previous_url", only: [:create]
  
  def index
  end

  def create
    @cart.add_item(params[:item_id])
    session[:cart] = @cart.cart_items
    redirect_to cart_path
  end

  def destroy
    @cart.remove_item(params[:item_id])
    redirect_to cart_path
  end

  def update
    @cart.add_item(params[:item_id])
    session[:cart] = @cart.cart_items
    redirect_to cart_path
  end

  private

  def cart_params
    params.permit(:item_id)
  end
  
  def save_previous_url
    session[:previous_url] = URI(request.referer || '').path
  end
end

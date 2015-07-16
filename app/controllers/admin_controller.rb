class AdminController < ApplicationController
  before_action :authorize_staff
  
  def index
    if params[:status].nil? || params[:status] == "all"
      @orders = Order.sorted
    else
      @orders = Order.sorted.where("status = ?", params[:status])
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:status)
  end
end

class UserTransactionsController < ApplicationController
  
  def index
    if current_user
      @transactions = current_user.user_transactions
    else
      redirect_to root_path
    end
  end
  
  def show
    @transaction = current_user.user_transactions.find(params[:id])  
  end
  
end

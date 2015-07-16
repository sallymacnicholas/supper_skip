class AddCartToUserTransaction < ActiveRecord::Migration
  def change
    add_column :user_transactions, :cart, :json
  end
end

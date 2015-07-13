class AddUserTransactionIdToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :user_transaction, index: true
    add_foreign_key :orders, :user_transactions
  end
end

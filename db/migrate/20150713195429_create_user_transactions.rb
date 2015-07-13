class CreateUserTransactions < ActiveRecord::Migration
  def change
    create_table :user_transactions do |t|
      t.integer :order_total
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :user_transactions, :users
  end
end

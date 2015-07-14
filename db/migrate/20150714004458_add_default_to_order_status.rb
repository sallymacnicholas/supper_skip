class AddDefaultToOrderStatus < ActiveRecord::Migration
  def change
    change_column_default :orders, :status, "ready for preparation"
  end
end

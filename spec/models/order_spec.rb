require "rails_helper"

describe Order, type: "model" do

  it "is valid when it has a user" do
    order = Order.new(user_id: 1)
    expect(order).to be_valid
  end

  it "is invalid when it does not have a user" do
    order = Order.new(user_id: nil)
    expect(order).not_to be_valid
  end

  it "has a relationship to user that works" do
    user = FactoryGirl.create(:user, email: "stuff@stuff.com")
    order = Order.create(user_id: user.id)

    expect(order.user).to be_truthy
  end

  it "has order items" do
    user2 = create(:user, full_name: "bob bob", email: "bob@gmail.com")
    item = create(:item)
    order = Order.create(user_id: user2.id, status: "paid", total_price: 500)
    OrderItem.create(order_id: order.id, item_id: item.id, quantity: 5)
    expect(order.order_items.count).to eq(1)
  end

  it "has a default sort by descending order" do
    user2 = create(:user, full_name: "bob bob", email: "bob@gmail.com")
    order = Order.create(user_id: user2.id, status: "paid", total_price: 500)
    order2 = Order.create(user_id: user2.id, status: "paid", total_price: 540)
    expect(Order.all).to eq([order2, order])
  end
  
  it "validates for status" do
    user = create(:user, full_name: "bob bob", email: "bob@gmail.com")
    order = Order.new(user_id: user.id, status: "paid", total_price: 500)
    expect(order).to be_valid

    order2 = Order.new(user_id: user.id, status: "not paid", total_price: 500)
    expect(order2).to_not be_valid
  end
  
  it "can only be cancelled if paid or ready for prep" do
    user = create(:user, full_name: "bob bob", email: "bob@gmail.com")
    order = Order.create(user_id: user.id, status: "paid", total_price: 500)
    order.cancel
    expect(order).to be_valid
    expect(order.status).to eq("cancelled")

    order2 = Order.create(user_id: user.id, status: "in preparation", total_price: 500)
    order2.cancel
    expect(order2.status).to eq("in preparation")
  end
  
  
end

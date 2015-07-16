# Implement simple recommendations including:
# 
# The ability to easily see your last order and add the same items to the current order
# When browsing an item, recommend 3 other items from that store that were ordered by customers who also ordered the item I'm viewing
# If 3 other items can't be found, pull the most popular overall items from that store

require "spec_helper"

describe "user looking for order suggestions", type: :feature do
  
  let!(:user) { User.create!(full_name: "Uncle Tan",
                             email: "uncletan@gmail.com",
                             password: "password",
                             password_confirmation: "password")}

  let!(:restaurant) { create(:restaurant) }
  let!(:category) { Category.create!(name: "Rolls") }
  
  before(:each) do
    restaurant.categories << category
    
    item = Item.new(title: "Rainbow Roll",
                        description: "So prideful",
                        unit_price: 1500,
                        categories: [category],
                        active: true)
    restaurant.items << item

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end
  
  it "can order from recent order history" do
    visit restaurant_path(restaurant)
    first(:button, "Add to cart").click
    visit cart_path
    click_on "Checkout"

    visit cart_path
    expect(page).to_not have_content("Rainbow Roll")
    expect(page).to_not have_content("So prideful")

    visit user_orders_path
    click_on "Order it again!"

    expect(current_path).to eq(user_order_path(user.most_recent_transaction))
    expect(page).to have_content("Rainbow Roll")
  end
end

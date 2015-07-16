require "spec_helper"

describe "a user canceling an order", type: :feature do
  include Capybara::DSL

  let!(:user) { User.create!(full_name: "Josh Cheek",
                             email: "cheeky@gmail.com",
                             password: "password",
                             password_confirmation: "password")}
  let!(:restaurant) {Restaurant.create!(name: "Existential Eats",
                                        description: "Our food fuels your existence. Literally.")}
  let!(:category) { Category.create!(name: "Philosophical Finger Foods")}

  before(:each) do
    restaurant.categories << category
    
    item = Item.new(title: "Nietzsche's Nutter Butters",
                    description: "Eternally recurring peanut butter snacks.",
                    unit_price: 100,
                    categories: [category],
                    active: true)
    restaurant.items << item

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end
  
  it "can cancel when status is ready for preparation" do
    visit restaurant_path(restaurant)
    
    first(:button, "Add to cart").click
    visit cart_path
    click_on "Checkout"
    
    expect(page).to have_content("Order Summary")
    expect(page).to have_content("Existential Eats")
    expect(page).to have_content("Order Total: $1.00")
    expect(page).to have_content("Ready For Preparation")
    
    order = user.most_recent_transaction.orders.first

    click_on "Cancel Order"
    expect(page).to have_content("Your order has been successfully cancelled.")
    expect(current_path).to eq(user_order_path(order.user_transaction))
  end

  it "cannot cancel when status is past ready for preparation" do
    visit restaurant_path(restaurant)

    first(:button, "Add to cart").click
    visit cart_path
    click_on "Checkout"

    expect(page).to have_content("Order Summary")
    expect(page).to have_content("Existential Eats")
    expect(page).to have_content("Order Total: $1.00")
    expect(page).to have_content("Ready For Preparation")
    
    order = user.most_recent_transaction.orders.first
    order.update_attributes(status: "in preparation")
    order.save!

    click_on "Cancel Order"
    expect(page).to have_content("Your order cannot be cancelled at this time.")
    expect(current_path).to eq(user_order_path(order.user_transaction))
  end
end

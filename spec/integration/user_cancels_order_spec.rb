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
  let!(:item) { Item.new(title: "Nietzsche's Nutter Butters",
    description: "Eternally recurring peanut butter snacks.",
    unit_price: 100)}

  before(:each) do
    restaurant.categories << category
    restaurant.items << item

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end
  it "can cancel when status is ready for preparation" do
    visit restaurant_path(restaurant)
    first(:button, "Add to cart").click
    click_on "Checkout"

    expect(page).to have_content("Order Summary")
    expect(page).to have_content("Existential Eats")
    expect(page).to have_content("Order Total: $1.00")
    expect(page).to have_content("Nietzsche's Nutter Butters")
    expect(page).to have_content("Ready For Preparation")

    click_on "Cancel Order"
    expect(page).to have_content("Your order has been successfully cancelled.")
    expect(current_path).to eq(user_orders_path(user))
  end
end

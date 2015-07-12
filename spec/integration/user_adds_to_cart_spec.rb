require "spec_helper"

describe "user adds to cart and", type: :feature do
  include Capybara::DSL
  
  let!(:user) { User.create!(full_name: "Uncle Tan",
                             email: "uncletan@gmail.com",
                             password: "password",
                             password_confirmation: "password")}
  let!(:restaurant_one) {Restaurant.create!(name: "Jorge's Pita Bar",
                                            description: "Hope you like falafel",
                                            slug: "jorges-pita-bar")}
  let!(:restaurant_two) { create(:restaurant) }
  

  before(:each) do
    category_one = Category.create!(name: "Things")
    restaurant_one.categories << category_one
    category_two = Category.create(name: "Rolls")
    restaurant_two.categories << category_two

    item_one = Item.new(title: "Falafel pita",
                        description: "The very best falafel",
                        unit_price: 1100,
                        categories: [category_one],
                        active: true)
    restaurant_one.items << item_one
    
    item_two = Item.new(title: "Rainbow Roll",
                        description: "So prideful",
                        unit_price: 1500,
                        categories: [category_two],
                        active: true)
    restaurant_two.items << item_two

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end
  
  it "can add one item to cart" do
    visit restaurant_path(restaurant_one)
    
    first(:button, "Add to cart").click
    
    expect(current_path).to eq(cart_path)
    expect(page).to have_content("Jorge's Pita Bar")
    expect(page).to have_content("Falafel pita")
    expect(page).to have_content("$11.00")
    expect(page).to have_content("Quantity: 1")
  end
  
  it "can add multiple items to cart" do
    visit restaurant_path(restaurant_one)
    first(:button, "Add to cart").click
    visit restaurant_path(restaurant_two)
    first(:button, "Add to cart").click

    expect(current_path).to eq(cart_path)
    expect(page).to have_content("Jorge's Pita Bar")
    expect(page).to have_content("Falafel pita")
    expect(page).to have_content("Sallys Sushi")
    expect(page).to have_content("Rainbow Roll")
  end
end 

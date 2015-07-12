require "spec_helper"

describe "owner managing items", type: :feature do
  include Capybara::DSL
  let!(:owner) { User.create!(full_name: "Jorge Tellez",
                              email: "jorge@isfrommexico.com",
                              password: "password",
                              password_confirmation: "password")}
  let!(:restaurant) {Restaurant.create!(name: "Jorge's Pita Bar",
                                        description: "Hope you like falafel",
                                        slug: "jorges-pita-bar")}
  
  before(:each) do
    owner.restaurant = restaurant
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(owner)
    restaurant.categories << Category.create(name: "Pita things")
  end 
  
  it "can visit owner restaurant show page" do
    visit root_path
    
    click_on "Manage Restaurant"

    expect(current_path).to eq(admin_restaurant_path(restaurant))
  end
  
  it "can create an item" do
    visit admin_restaurant_path(restaurant)
    
    click_on "Manage Items"
    
    expect(current_path).to eq(admin_restaurant_items_path(restaurant))
    
    click_on "Create Item"
    
    expect(current_path).to eq(new_admin_restaurant_item_path(restaurant))
    save_and_open_page
    fill_in "Title", with: "Pita"
    fill_in "Description", with: "A delightful pita"
    fill_in "Price (in cents)", with: "1100"
    select "Pita things", from: "item[categories][]"
    
    click_on "Add Item"
    
    expect(current_path).to eq(admin_restaurant_items_path(restaurant))
    expect(page).to have_content("Pita")
    expect(page).to have_content("A delightful pita")
  end

end

require "spec_helper"

describe "cook", type: :feature do
  include Capybara::DSL
  let!(:owner) { User.create!(full_name: "Jorge Tellez",
                              email: "jorge@isfrommexico.com",
                              password: "password",
                              password_confirmation: "password")}
  let!(:restaurant) {Restaurant.create!(name: "Jorge's Pita Bar",
                                        description: "Hope you like falafel",
                                        slug: "jorges-pita-bar")}
  let!(:user) { User.create!(full_name: "Horace Williams",
                             email: "horace@isahipster.com",
                             password: "password",
                             password_confirmation: "password")}
  let(:shopper) { User.create!(full_name: "Josh Mejia",
                               email: "josh@mejia.com",
                               password: "password",
                               password_confirmation: "password")}
  let!(:category) { Category.create!(name: "Sauces")}
  let!(:role) { Role.create!(name: "cook")}

  before(:each) do
    owner.restaurant = restaurant
    UserRestaurantRole.create(role_id: role.id, user_id: user.id, restaurant_id: restaurant.id)

    item = Item.new(title: "Hummus",
                    description: "Mushed chick peas",
                    unit_price: 100,
                    categories: [category],
                    active: true)
    restaurant.items << item
    
    
  end
  
  it "can see the order summaries but not the admin panel" do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
    
    visit admin_restaurant_path(restaurant)
    expect(current_path).to eq(admin_restaurant_path(restaurant))
    
    expect(page).to have_content "Recent Orders"
    expect(page).to_not have_content "Admin Panel"
  end
  
  
end

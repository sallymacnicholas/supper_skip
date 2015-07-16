require "spec_helper"

describe "staff", type: :feature do
  include Capybara::DSL
  attr_reader :order
  
  let!(:owner) { User.create!(full_name: "Jorge Tellez",
                              email: "jorge@isfrommexico.com",
                              password: "password",
                              password_confirmation: "password")}
  let!(:restaurant) {Restaurant.create!(name: "Jorge's Pita Bar",
                                        description: "Hope you like falafel",
                                        slug: "jorges-pita-bar")}
  let!(:cook) { User.create!(full_name: "Horace Williams",
                             email: "horace@isahipster.com",
                             password: "password",
                             password_confirmation: "password")}
  let!(:delivery) { User.create!(full_name: "Justin Holmes",
                                 email: "justin@isadolphintrainer.com",
                                 password: "password",
                                 password_confirmation: "password")}
  let(:shopper) { User.create!(full_name: "Josh Mejia",
                               email: "josh@isamejia.com",
                               password: "password",
                               password_confirmation: "password")}
  let!(:category) { Category.create!(name: "Sauces")}
  let!(:role_cook) { Role.create!(name: "cook")}
  let!(:role_delivery) { Role.create!(name: "delivery")}

  before(:each) do
    owner.restaurant = restaurant
    UserRestaurantRole.create!(role_id: role_cook.id,
                               user_id: cook.id,
                               restaurant_id: restaurant.id)
    UserRestaurantRole.create!(role_id: role_delivery.id,
                               user_id: delivery.id,
                               restaurant_id: restaurant.id)

    item = Item.new(title: "Hummus",
                    description: "Mushed chick peas",
                    unit_price: 100,
                    categories: [category],
                    active: true)
    restaurant.items << item
    session_cart = { "#{item.id}" => 1 }
    cart = Cart.new(session_cart)
    OrderCreator.execute_order(cart, shopper)
    @order = restaurant.orders.first
  end
  
  it "can see the order summaries but not the admin panel" do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(cook)
    
    visit admin_restaurant_path(restaurant)
    expect(current_path).to eq(admin_restaurant_path(restaurant))
    
    expect(page).to have_content "Recent Orders"
    expect(page).to have_content order.formatted_date
    expect(page).to_not have_content "Admin Panel"
  end

  it "with cook role can change order status through pipeline" do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(cook)

    visit admin_restaurant_path(restaurant)
    expect(current_path).to eq(admin_restaurant_path(restaurant))
    
    within('.table.table-striped.orders-table') do
      expect(page).to have_content "ready for preparation"
      click_on "Prepare order"
    end
    
    expect(current_path).to eq(admin_restaurant_path(restaurant))
    within('.table.table-striped.orders-table') do
      expect(page).to_not have_content "ready for preparation"
      expect(page).to have_content "in preparation"
      click_on "Send to delivery"
    end
    
    expect(current_path).to eq(admin_restaurant_path(restaurant))
    within('.table.table-striped.orders-table') do
      expect(page).to_not have_content "in preparation"
      expect(page).to have_content "ready for delivery"
    end
  end
  
  it "with a cook role can mark order ready for delivery" do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(delivery)
    order.update_attributes(status: "ready for delivery")
    order.save!
    
    visit admin_restaurant_path(restaurant)
    expect(current_path).to eq(admin_restaurant_path(restaurant))
    
    within('.table.table-striped.orders-table') do
      expect(page).to have_content "ready for delivery"
      click_on "Deliver order"
    end

    expect(current_path).to eq(admin_restaurant_path(restaurant))
    within('.table.table-striped.orders-table') do
      expect(page).to_not have_content "ready for delivery"
      expect(page).to have_content "out for delivery"
      click_on "Mark as delivered"
    end

    expect(current_path).to eq(admin_restaurant_path(restaurant))
    within('.table.table-striped.orders-table') do
      expect(page).to_not have_content "out for delivery"
      expect(page).to have_content "completed"
    end
  end
end

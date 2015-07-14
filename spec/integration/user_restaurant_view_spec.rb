require "spec_helper"

describe "user viewing restaurant", type: :feature do
  include Capybara::DSL
  let!(:owner) { User.create!(full_name: "Jorge Tellez",
    email: "jorge@isfrommexico.com",
    password: "password",
    password_confirmation: "password")}
  let!(:restaurant) {Restaurant.create!(name: "Jorge's Pita Bar",
    description: "Hope you like falafel",
    slug: "jorges-pita-bar")}
  let!(:user) { User.create!(full_name: "Horace Williams",
    email: "horace@isfromyale.com",
    password: "password",
    password_confirmation: "password")}

  before(:each) do
    owner.restaurant = restaurant
  end

  it "can view categories in a restaurant" do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)

    visit restaurant_path(grestaurant)
    save_and_open_page
    expect(page).to have_content("Jorge's Pita Bar")
    expect(page).to have_content("Hope you like falafel")
    expect(current_path).to eq(restaurant_path(restaurant))
  end

end

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
  end

  it "can visit owner restaurant show page" do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(owner)

    visit root_path

    click_on "Manage Restaurant"

    expect(current_path).to eq(admin_restaurant_path(restaurant))
  end

end

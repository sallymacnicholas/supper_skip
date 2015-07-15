require "spec_helper"

describe "admin assigning roles to staff", type: :feature do
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

  let!(:role) { Role.create!(name: "fucking cook")}

  before(:each) do
    owner.restaurant = restaurant
  end

  it "can add staff to the restaurant" do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(owner)

    visit admin_restaurant_path(restaurant)
    click_on "Manage Staff"
    expect(current_path).to eq(admin_restaurant_user_restaurant_roles_path(restaurant))
    click_on "Add Staff Member"
    expect(current_path).to eq(new_admin_restaurant_user_restaurant_role_path(restaurant))


    fill_in "Email", with: "horace@isahipster.com"
    select 'fucking cook', from: "roles"
    click_on "Submit"
    expect(current_path).to eq(admin_restaurant_user_restaurant_roles_path(restaurant))

  end
end

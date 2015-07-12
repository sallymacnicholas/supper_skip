require "rails_helper"

describe "the owner" do
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

  it "can update their restaurant's information" do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(owner)

    visit '/'

    within ".menu_right" do
      click_on "Manage Restaurant"
    end

    expect(current_path).to eq('/admin/restaurants/jorges-pita-bar')
    save_and_open_page
    click_on 'Manage Restaurant Profile'
    expect(current_path).to eq('/admin/restaurants/jorges-pita-bar/edit')

    fill_in "Name", with: "Jorge's Ice Cream"
    fill_in "Description", with: "Home-churned ice cream"
    fill_in "URL Name", with: "jorges-ice-cream"
    click_on "Update my restaurant"
    #For this form, have the fields pre-filled in with values so nothing is being submitted nil

    expect(current_path).to eq('/restaurants/jorges-ice-cream')
  end

  it "can not update another restaurant's information" do
    different_owner = User.create!(full_name: "Morgan Miller",
                                   email: "morgan@isnotfrommexico.com",
                                   password: "password",
                                   password_confirmation: "password")
    different_restaurant = Restaurant.create!(name: "Morgans Munchies",
                                              description: "Not just for stoners!")
    different_owner.restaurant = different_restaurant

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(different_owner)

    visit '/admin/restaurants/jorges-pita-bar'
    expect(current_path).to eq(root_path)
  end

end

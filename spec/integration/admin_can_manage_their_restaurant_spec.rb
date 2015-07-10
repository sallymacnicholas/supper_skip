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
    click_on 'Update Restaurant Info'
    expect(current_path).to eq('/admin/restaurants/jorges-pita-bar/edit')
    
    fill_in "Name", with: "Jorge's Ice Cream"
    fill_in "Description", with: "Home-churned ice cream"
    fill_in "URL Name", with: "jorges-ice-cream"
    click_on "Update my restaurant"
    #For this form, have the fields pre-filled in with values so nothing is being submitted nil
    
    expect(current_path).to eq('/restaurants/jorges-ice-cream')
  end
  
  it "can not update another restaurant's information" do
    
  end
  
  #write sad path
end

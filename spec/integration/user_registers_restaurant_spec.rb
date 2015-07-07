require "rails_helper"

describe "the user" do
  include Capybara::DSL
  attr_reader :user
  let(:restaurant) { Restaurant.new(name: "Ninja Turtle's Pizza",
                                   description: "Totally tubular pizza!") }
   def mock_user
     user = create(:user)
     allow_any_instance_of(ApplicationController).
       to receive(:current_user).
       and_return(user)
   end

  it "can register a restaurant with default slug" do
    mock_user
    visit root_path

    within '.footer-section' do
      click_on "Open a Restaurant"
    end

    fill_in "Name", with: restaurant.name
    fill_in "Description", with: restaurant.description
    click_on "Create Restaurant"

    new_restaurant = Restaurant.all.last
    
    expect(current_path).to eq(restaurant_path(new_restaurant))
  end
end

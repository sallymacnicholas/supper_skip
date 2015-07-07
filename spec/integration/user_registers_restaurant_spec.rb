require "rails_helper"

describe "the user" do
  include Capybara::DSL
  attr_reader :user
  let(:restaurant) { Restaurant.new(name: "Ninja Turtle's Pizza",
                                   description: "Totally tubular pizza!") }
  
  it "can register a restaurant with default slug" do
    visit root_path
    
    within '.footer-section' do
      click_on "Open a Restaurant"
    end
    
    fill_in "restaurant[name]", with: restaurant.name
    fill_in "restaurant[description]", with: restauraunt.description
    click_on "Create Restaurant"
    
    new_restaurant = Restaurant.all.last
    expect current_path.to eq(restaurant_path(new_restaurant))
  end
end

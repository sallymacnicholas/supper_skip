require "rails_helper"

RSpec.describe ItemsController, type: :controller do
  let!(:restaurant) {Restaurant.create!(name: "Jorge's Pita Bar",
    description: "Hope you like falafel",
    slug: "jorges-pita-bar")}
  let!(:restaurant2) {Restaurant.create!(name: "Horace's Pizza Palace",
    description: "Hope you like pizza",
    slug: "horaces-pizza-palace")}
  let!(:restaurant3) {Restaurant.create!(name: "Mike's Asian Bistro",
    description: "Hope you like msg",
    slug: "mikes-asian-bistro")}

  it "can list all the restaurants" do
    expect(Restaurant.all.count).to eq(3)
  end

end

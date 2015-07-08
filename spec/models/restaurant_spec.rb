require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  #either create or build lets you overwrite attributes
  let(:mock_restaurant) { create(:restaurant) }

  it "needs a name" do
    invalid_restaurant = Restaurant.new(description: "invalid restaurant")

    expect(invalid_restaurant).to_not be_valid
  end
  
  it "has a unique name" do
    expect(mock_restaurant).to be_valid
    
    invalid_restaurant = Restaurant.new(name: "Sallys Sushi")
    expect(invalid_restaurant).to_not be_valid
  end
  
  it "sets a slug when no slug is given" do
    expect(mock_restaurant.slug).to eq("sallys-sushi")
  end
  
  it "creates a custom slug" do
    slugged_restaurant = create(:restaurant, slug: "sallys awesome sushi")

    expect(slugged_restaurant.slug).to eq("sallys-awesome-sushi")
  end
  
  it "has a unique slug" do
    expect(mock_restaurant).to be_valid
    expect(mock_restaurant.slug).to eq("sallys-sushi")
    
    invalid_restaurant = Restaurant.new(name: "Sallys Awesome Sushi",
                                        description: "so much raw fish",
                                        slug: "sallys-sushi")
    
    expect(invalid_restaurant).to_not be_valid
  end
  
  it "needs a description" do
    invalid_restaurant = Restaurant.new(name: "Sallys Awesome Sushi",
                                        slug: "sallys-sushi")

    expect(invalid_restaurant).to_not be_valid
  end
end

require 'rails_helper'

RSpec.describe Restaurant, type: :model do
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
  
  it "has items" do
    expect([]).to eq(mock_restaurant.items)

    category = mock_restaurant.categories.create!(name: "Rolls")
    mock_item     = Item.new(title: "Rainbow Roll",
                             description: "So prideful",
                             unit_price: 1500,
                             categories: [category],
                             active: true)
    
    mock_restaurant.items << mock_item
    expect("Rainbow Roll").to eq(mock_restaurant.items.last.title)
    expect(1).to eq(mock_restaurant.items.count)
  end
  
  it "has categories" do
    expect([]).to eq(mock_restaurant.categories)

    category = mock_restaurant.categories.create!(name: "Rolls")
    
    expect([category]).to eq(mock_restaurant.categories)
  end
  
  it "has items with categories" do
    expect([]).to eq(mock_restaurant.items)

    category = mock_restaurant.categories.create!(name: "Rolls")
    mock_item     = Item.new(title: "Rainbow Roll",
                             description: "So prideful",
                             unit_price: 1500,
                             categories: [category],
                             active: true)

    mock_restaurant.items << mock_item
    expect([category]).to eq(mock_restaurant.items.last.categories)
  end
  
  it "doesn't have another restaurant's items" do
    other_restaurant = Restaurant.create!(name: "Chelsea's Cookies",
                                          description: "chocolate chip yum")
    other_category   = other_restaurant.categories.create!(name: "Gluten free")
    other_item       = Item.new(title: "Gingerbread",
                                description: "The worst cookie",
                                unit_price: 2000,
                                categories: [other_category],
                                active: true)
    other_restaurant.items << other_item      
    
    mock_category      = mock_restaurant.categories.create!(name: "Rolls")
    mock_item          = Item.new(title: "Rainbow Roll",
                                  description: "So prideful",
                                  unit_price: 1500,
                                  categories: [mock_category],
                                  active: true)
    mock_restaurant.items << mock_item
    
    expect("Rainbow Roll").to eq(mock_restaurant.items.last.title)
    expect(1).to eq(mock_restaurant.items.count)
    expect("Gingerbread").to eq(other_restaurant.items.last.title)
    expect(1).to eq(other_restaurant.items.count)
  end
  
  it "doesn't have another restaurant's categories" do
    other_restaurant = Restaurant.create!(name: "Chelsea's Cookies",
                                          description: "chocolate chip yum")
    other_category   = other_restaurant.categories.create!(name: "Gluten free")
    mock_category    = mock_restaurant.categories.create!(name: "Rolls")

    expect("Rolls").to eq(mock_restaurant.categories.last.name)
    expect("Gluten free").to eq(other_restaurant.categories.last.name)
  end
  
  it "has only one owner" do
    mock_user  = User.create!(full_name: "Sally",
                              email: "sdub@gmail.com",
                              password: "password",
                              password_confirmation: "password")
    other_user = User.create!(full_name: "Chelsea",
                              email: "cdub@gmail.com",
                              password: "password", 
                              password_confirmation: "password")
    other_restaurant = Restaurant.create!(name: "Chelsea's Cookies",
                                          description: "chocolate chip yum",
                                          user: other_user)
    mock_restaurant.user = mock_user
    
    expect(mock_restaurant.user).to eq(mock_user)
    expect(other_restaurant.user).to eq(other_user)
    expect(mock_restaurant.user).to_not eq(other_user)
    expect(other_restaurant.user).to_not eq(mock_user)
  end

  it "has featured restaurants" do
    one = Restaurant.create(name: "Sally's Sushi", description:"alskdfk")
    two = Restaurant.create(name: "Chelsea's Cupcakes", description:"alskdfk")
    three = Restaurant.create(name: "Morgan's Munchies", description:"alskdfk")

    expect(Restaurant.featured_restaurants.count).to eq(3)
    expect(Restaurant.featured_restaurants).to include(one)
  end
end

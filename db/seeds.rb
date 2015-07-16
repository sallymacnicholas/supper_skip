require 'faker'

class NewSeed
  attr_reader :users, :owners, :restaurants
  
  def initialize
    generate_users
    generate_restaurants
    generate_categories
    generate_items
    generate_order
    generate_roles
  end

  def generate_users
    @owners = User.create!([
        { full_name:             "Morgan Miller",
          email:                 "mdub@gmail.com",
          password:              "password",
          password_confirmation: "password" },
        { full_name:             "Sally MacNicholas",
          email:                 "sdub@gmail.com",
          password:              "password",
          password_confirmation: "password",
          display_name:          "Speedball Sally" },
        { full_name:             "Chelsea Worrel",
          email:                 "cdub@gmail.com",
          password:              "password",
          password_confirmation: "password",
          display_name:          "C Dub" }
      ])
    
    @users = User.create!([
        { full_name:             "Josh Cheek",
          email:                 "demo+josh@jumpstartlab.com",
          password:              "password",
          password_confirmation: "password" },
        { full_name:             "Rachel Warbelow",
          email:                 "demo+rachel@jumpstartlab.com",
          password:              "password",
          password_confirmation: "password" },
        { full_name:             "Jeff Casimir",
          email:                 "demo+jeff@jumpstartlab.com",
          password:              "password",
          password_confirmation: "password",
          display_name:          "j3" },
        { full_name:             "Jorge Tellez",
          email:                 "demo+jorge@jumpstartlab.com",
          password:              "password",
          password_confirmation: "password",
          display_name:          "novohispano" }
      ])
  end
  
  def random_user
    @users.sample
  end
  
  def generate_restaurants
    unowned_restaurants = Restaurant.create!([
      { name: "Morgan's Munchies", description: "Not just for stoners.", slug: "morgans-munchies" },
      { name: "Sally's Sushi", description: "The best food from under the sea.", slug: "sallys-sushi" },
      { name: "Chelsea's Cupcakes", description: "A strictly G-rated bakery.", slug: "chelseas-cupcakes" }
    ])
    
    restaurants = unowned_restaurants.zip(owners)
    restaurants.each do |restaurant, owner|
      owner.restaurant = restaurant
    end
    @restaurants = restaurants.map { |r, o| r }
  end
  
  def generate_categories
    categories = [Category.create([
        { name: "Chips" },
        { name: "Candy" },
        { name: "Ice Cream" },
        { name: "Popcorn" }
      ]),
      Category.create([
          { name: "Rolls" },
          { name: "Sashimi" },
          { name: "Nigiri" },
          { name: "Appetizers" }
        ]),
      Category.create([
          { name: "Cupcakes" },
          { name: "Mini Cupcakes" },
          { name: "Cake Pops" },
          { name: "Gluten Free" }
        ])
      ]
    
    @restaurants.each_with_index do |restaurant, i|
      restaurant.categories << categories[i]
    end
  end
  
  def generate_items
    10.times do
      item = Item.new(title: Faker::Commerce.product_name, description: Faker::Lorem.sentence, unit_price: 5000, categories: @restaurants[0].categories.sample(2), active: true)
      @restaurants[0].items << item
      item.image = File.open("#{Rails.root}/app/assets/images/donuts.jpg")
      item.save
    end

    10.times do
      item = Item.new(title: Faker::Commerce.product_name, description: Faker::Lorem.sentence, unit_price: 5000, categories: @restaurants[1].categories.sample(2), active: true)
      @restaurants[1].items << item 
      item.image = File.open("#{Rails.root}/app/assets/images/sushi.jpg")
      item.save
    end

    10.times do
      item = Item.new(title: Faker::Commerce.product_name, description: Faker::Lorem.sentence, unit_price: 5000, categories: @restaurants[2].categories.sample(2), active: true)
      @restaurants[2].items << item
      item.image = File.open("#{Rails.root}/app/assets/images/cupcake.jpg")
      item.save
    end
  end

  def carts
    [
      { "1" => 2, "3" => 1, "4" => 1 },
      { "2" => 2, "5" => 1 },
      { "8" => 1, "6" => 1, "9" => 3 },
      { "5" => 5 },
      { "5" => 1, "18" => 1 },
      { "10" => 1, "12" => 1, "13" => 2, "11" => 3 },
      { "1" => 4, "9" => 1},
      { "17" => 2, "2" => 1},
      { "3" => 1, "4" => 1, "5" => 1, "6" => 1},
      { "18" => 2},
      { "7" => 1, "14" => 1, "20" => 4},
      { "3" => 1 },
      { "5" => 1, "15" => 5 }
    ]
  end

  def generate_order
    carts.each do |session_cart|
      cart = Cart.new(session_cart)
      OrderCreator.execute_order(cart, random_user)
    end
    change_order_statuses
  end
  
  def generate_roles
    Role.create!(name: "cook")
    Role.create!(name: "delivery")
  end

  def change_order_statuses
    1.times do |i|
      order = Order.find(i+1)
      order.status = "in preparation"
      order = Order.find(i+5)
      order.status = "ready for delivery"
    end
  end
end

NewSeed.new

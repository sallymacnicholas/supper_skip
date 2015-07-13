FactoryGirl.define do  
  
  factory :user_transaction do
    order_total 1
    user nil
  end

  
  factory :restaurant do
    name "Sallys Sushi"
    description "So much raw fish"
  end


  sequence :name do |n|
    "category#{n}"
  end

  sequence :title do |n|
    "title#{n}"
  end

  factory :admin do
    full_name "Yolo Ono"
    email "admin@admin.com"
    password "password"
    display_name "Admin"
  end

  factory :user do
    full_name "John Bob Smith"
    email "john@bobo.com"
    password "test"
    password_confirmation "test"
    display_name "John Smithy"
  end

  factory :item do
    title
    description "some stuff"
    unit_price 500
    active true
    before(:create) do |item|
      item.categories << create(:category)
    end
  end

  factory :category do
    name
  end
end

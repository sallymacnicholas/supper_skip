FactoryGirl.define do  factory :notification do
    email "MyString"
restaurant_id 1
role_id 1
  end
  factory :user_restaurant_role do
    user nil
role nil
restaurant nil
  end
  factory :role do
    name "MyString"
  end
  
  
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

require "rails_helper"

describe "the user" do
  include Capybara::DSL
  attr_reader :item, :user

  it "sees a Login button on homepage" do
    visit root_path

    expect(page).to have_link("Login")
    expect(page).to_not have_link("Logout")
  end

  it "sees a Create Account button on homepage" do
    visit root_path

    expect(page).to have_link("Create Account")
  end

  it "a user going to a non defined route gets redirected to the home page" do
    visit "/something"

    expect(current_path).to eq(root_path)
  end

  it "can see a signup button" do
    visit root_path
    click_link("Login")

    expect(page).to have_link("here")
  end

  it "can create an account" do
    user = build(:user)

    visit root_path
    click_link("Login")
    click_link("here")
    fill_in "user[full_name]", with: user.full_name
    fill_in "user[display_name]", with: user.display_name
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    fill_in "user[password_confirmation]", with: user.password
    click_button("Create my account!")

    expect(page).to have_content("Account successfully created. ")
  end

  it "cannot create an account with invalid credentials" do
    user = create(:user)

    visit root_path
    click_link("Login")
    click_link("here")
    fill_in "user[full_name]", with: "123"
    fill_in "user[display_name]", with: "a"
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: "pass"
    fill_in "user[password_confirmation]", with: "word"
    click_button("Create my account!")

    expect(page).to have_content("password_confirmation: doesn't match")
    expect(page).to have_content("full_name: Incorrect name format")
    expect(page).to have_content("email: has already been taken")
    expect(page).to have_content("display_name: is too short")
  end

  it "sees a Logout button instead of Login " do
    mock_user

    visit root_path

    expect(page).to_not have_link("Login")
    expect(page).to have_link("Logout")
  end

  it "cannot see another users information" do
    exisiting_user = create(:user, full_name: "Sue Sue", email: "sue@sue.com")
    mock_user
    Order.create(user_id: exisiting_user.id, status:  "ordered")

    visit root_path
    click_link_or_button("Past Orders")

    expect(page).to_not have_link("1")
  end

  it "can log out" do
    mock_user

    visit root_path
    click_link("Logout")

    expect(page).to have_content("Successfully logged out")
  end

  describe "the past orders view" do
    it "shows the past orders for a user" do
      mock_user
      visit root_path

      click_link("Past Orders")

      expect(current_path).to eq(orders_path)
      expect(page).to have_content("Your Past Orders")
    end
  end

  def mock_user
    @user = create(:user)
    allow_any_instance_of(ApplicationController).
    to receive(:current_user).
    and_return(user)
  end

  def create_one_item_with_one_category
    image = create(:image)
    @item = create(:item, image_id: image.id)
  end

  def add_item_five_times_to_cart
    visit menu_path
    5.times do
      first(:button, "Add to cart").click
    end
  end

  it "sees all restaurants on homepage" do
    one = Restaurant.create(name: "Sally's Sushi", description:"alskdfk")
    two = Restaurant.create(name: "Chelsea's Cupcakes", description:"alskdfk")
    three = Restaurant.create(name: "Morgan's Munchies", description:"alskdfk")

    category_one = one.categories.create(name: "Rolls")
    category_two = two.categories.create(name: "Gluten Free")
    category_three = three.categories.create(name: "Hungry Hungry Hippo")

    one_item = Item.new(title: "Rainbow Roll", description: "pride roll", unit_price: 1000, categories: [category_one])
    two_item = Item.new(title: "Chocolate Chip", description: "yum", unit_price: 1000, categories: [category_two])
    three_item = Item.new(title: "Cheetos", description: "cheesy", unit_price: 1000, categories: [category_three])

    one.items << one_item
    two.items << two_item
    three.items << three_item

    visit root_path

    within("#featured-restaurants") do
      expect(page).to have_content(one.name)
      expect(page).to have_content(two.name)
      expect(page).to have_content(three.name)
    end
  end

  it "sees a dropdown of all restaurants on all pages" do
    one = Restaurant.create(name: "Jorge's Pita Bar", description:"alskdfk")
    two = Restaurant.create(name: "Horace's Pizza Palace", description:"alskdfk")
    three = Restaurant.create(name: "Mike's Asian Bistro", description:"alskdfk")

    visit root_path

    within(".dropdown-menu") do
      click_on "Jorge's Pita Bar"
      expect(current_path).to eq(restaurant_path(one))

      click_on "Horace's Pizza Palace"
      expect(current_path).to eq(restaurant_path(two))

      click_on "Mike's Asian Bistro"
      expect(current_path).to eq(restaurant_path(three))
    end
  end
end

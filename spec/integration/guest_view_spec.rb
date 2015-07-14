require "spec_helper"

describe "the guest view", type: :feature do
  describe "the home page" do

    xit "has a navbar" do
      visit root_path

      # expect(page).to have_link("Home")
      expect(page).to have_link("Menu")

      within (".menu_right") do
        expect(page).to have_link("Login")
        expect(page).to_not have_link("Past Orders")
      end
    end

    xit "redirects a guest to the home page when going to a non existing url" do
      visit "/something"

      expect(current_path).to eq(root_path)
    end

    xit "redirects a guest to home when going to admin dashboard" do
      visit "/something"

      expect(current_path).to eq(root_path)
    end

    xit "has no link to admin login" do
      visit root_path

      expect(page).not_to have_link("Admin")
    end

    xit "goes to the menu page" do
      visit root_path

      page.click_link("Menu")
      expect(current_path).to eq(menu_path)
    end

    xit "has a cart link" do
      visit root_path

      within (".menu_right") do
        expect(page).to have_css(".glyphicon-shopping-cart")
      end
    end
  end

  describe "the menu view" do
    xit "shows all the menu items" do
      create_item

      visit menu_path

      expect(page).to have_content("some cheese stuff")
      expect(page).to have_content("milk")
    end

    xit "shows the loaded image for each item" do
      create_item

      visit menu_path

      expect(page.find(".menu_list_img")["src"]).
        to have_content("heart_pizza.gif")
    end

    xit "has a side navbar for menu categories" do
      visit menu_path

      within(".sidebar-nav") do
        Category.all.each do |category|
          expect(page).to have_link(category.name)
        end
      end
    end

    xit "links to the correct menu categories" do
      create(:category, name: "Salads")

      visit menu_path
      page.click_link("Salads")

      expect(current_path).to eq(menu_path)
    end

    xit "has add-to-cart links for each item" do
      create_item

      visit menu_path

      within first(".item-box") do
        expect(page).to have_button("Add to cart")
      end
    end
  end

  describe "prohibited paths" do
    xit "redirects the guest to the root when attempting to visit orders_path" do
      visit orders_path

      expect(current_path).to eq(root_path)
    end

    xit "does not allow guest access to the admin page" do
      visit admin_path

      expect(current_path).to eq(root_path)
    end

    xit "does not allow guest access to user pages" do
      user = create(:user)
      visit admin_show_user_path(user.id)

      expect(current_path).to eq(root_path)
    end
  end

  def create_item
    image = create(:image)
    create(:item,
           title: "milk",
           description: "some cheese stuff",
           image_id: image.id)
  end
end

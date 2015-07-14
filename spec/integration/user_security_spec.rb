require "spec_helper"

describe "users cannot access any admin things", type: :feature do

  describe "admin dashboard" do

    xit "cannot access the admin dashboard" do
      mock_user

      visit admin_path

      expect(current_path).to eq(root_path)
    end
  end

  describe "items listing" do

    xit "cannot access items index as a user" do
      mock_user

      visit admin_items_path

      expect(current_path).to eq(root_path)
    end

    xit "cannot create a new item" do
      mock_user

      visit new_admin_item_path

      expect(current_path).to eq(root_path)
    end
  end

  describe "categories listing" do

    xit "cannot access categories index as a user" do
      mock_user

      visit admin_categories_path

      expect(current_path).to eq(root_path)
    end

    xit "cannot create a new category" do
      mock_user

      visit new_admin_category_path

      expect(current_path).to eq(root_path)
    end

    xit "cannot edit a category" do
      mock_user
      cat = create(:category)

      visit edit_admin_category_path(cat.id)

      expect(current_path).to eq(root_path)
    end

  end

  def mock_user
    user = create(:user)
    allow_any_instance_of(ApplicationController).
      to receive(:current_user).
      and_return(user)
  end
end

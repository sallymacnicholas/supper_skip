class HomepageController < ApplicationController
  def index
    @restaurants = Restaurant.all
  end
  
  def not_found
    redirect_to root_path
  end
end

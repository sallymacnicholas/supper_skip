class UsersController < ApplicationController
  def new
    if current_user
      redirect_to root_path
    end
    @user = User.new
  end

  def create
    user = User.create(user_params)
    if user.errors.any?
      user.errors.each do |field, message|
        flash["#{field}"] = "#{field}: #{message}"
      end
      redirect_to new_user_path
    else
      session[:user_id] = user.id
      flash[:success] = "Account successfully created. You are logged in!"
      redirect_to root_path
    end
    notification = Notification.find_by(email: user_params[:email])
    if notification
      UserRestaurantRole.create(user_id:user.id, restaurant_id: notification.restaurant_id, role_id: notification.role_id)
      notification.destroy
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :full_name,
      :display_name,
      :email,
      :password,
      :password_confirmation
    )
  end
end

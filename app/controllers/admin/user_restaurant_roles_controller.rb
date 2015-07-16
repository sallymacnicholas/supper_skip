class Admin::UserRestaurantRolesController < ApplicationController
  before_action :set_restaurant

  def index
    @staff = @restaurant.users
  end

  def new
    @staff_member = UserRestaurantRole.new
    @roles = Role.all
  end

  def create
    # binding.pry
   @user = User.find_by(email: params[:email])
   role = params[:roles].to_i
    if @user.nil?
       notification = Notification.find_by(email: params[:email])
       Notification.create(email: params[:email], restaurant_id: @restaurant.id, role_id: role) unless notification
       NotificationMailer.notification_email(params[:email], current_user, @restaurant).deliver
       if notification
         flash[:notice] = "Email has already been sent!"
      else
      flash[:notice] = "Email sent!"
       end
       redirect_to admin_restaurant_user_restaurant_roles_path(@restaurant)
     else
       user_role = UserRestaurantRole.new(user_id: @user.id, role_id: params[:roles].to_i, restaurant_id: @restaurant.id )
       if user_role.save
         flash[:message] = "You have successfully added #{@user.full_name} as a '#{@user.roles.last.name}'"
         NotificationMailer.confirmation_email(params[:email], @restaurant).deliver
         redirect_to admin_restaurant_user_restaurant_roles_path(@restaurant)
       else
         flash[:notice] = "You're new staff was not saved!"
         render :new
       end
     end

#      user = User.find_by(email: valid_params[:email])
# role = StaffRole.find_by(name: valid_params[:staff_role])
# if user
#   user.user_staff_roles.new(restaurant_id: owned_restaurant.id, staff_role: role)
#   if user.save
#     redirect_to restaurant_admin_dashboard_index_path
#     flash[:notice] = "You successfully added #{user.role} #{user.full_name}!"
#   else
#     render :new
#   end
# else
#   invite = Invite.find_by(email: valid_params[:email])
#   Invite.create(email: valid_params[:email], restaurant_id: owned_restaurant.id, staff_role_id: role.id) unless invite
#   InviteMailer.invite_email(valid_params[:email], current_user, owned_restaurant).deliver_now
#   flash[:notice] = "Email sent!"
#   redirect_to restaurant_admin_dashboard_index_path
# end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find_by_slug(params[:restaurant_slug])
  end

  def role_params
    params.require(:user_restaurant_roles).permit(:role_id, :user_id, :restaurant_id)
  end
end

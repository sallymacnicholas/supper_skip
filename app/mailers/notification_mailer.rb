class NotificationMailer < ApplicationMailer
  def notification_email(email_address, owner, restaurant)
   @restaurant = restaurant
   @owner = owner
   mail(to: email_address, subject: "Create an Eatsy Account!!!!", from: "#{owner.full_name}@#{restaurant.name}.com")
 end
end

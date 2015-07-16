class NotificationMailer < ApplicationMailer
  def notification_email(email_address, owner, restaurant)
    @restaurant = restaurant
    @owner = owner
   mail(to: email_address, subject: "Create an Eatsy Account!!!!", from: "hello@eatsy.com")
 end

 def confirmation_email(email_address, restaurant)
   @restaurant = restaurant
   mail(to: email_address, subject: "You have been signed up as a staff member of #{@restaurant}", from: "hello@eatsy.com")
 end

end

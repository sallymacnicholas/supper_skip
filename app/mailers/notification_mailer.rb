class NotificationMailer < ApplicationMailer
  def notification_email(email_address, owner, restaurant)
   @restaurant = restaurant
   @owner = owner
   mail(to: email_address, subject: "Create an Eatsy Account!!!!", from: "hello@eatsy.com")
 end
end

class UserTransaction < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  def formatted_created_at
    formatted_time(created_at)
  end

  def formatted_updated_at
    formatted_time(updated_at)
  end

  def formatted_date
    created_at.localtime.strftime("%b %-d, %Y")
  end

  def formatted_hour
    created_at.localtime.strftime("%I:%M%P")
  end
  
  def formatted_time(time_type)
    time_type.localtime.strftime("%I:%M%P on %a, %b %-d, %Y")
  end
  
  def total_dollar_amount
    order_total / 100.00
  end
end

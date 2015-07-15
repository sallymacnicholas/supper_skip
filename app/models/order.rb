class Order < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  
  belongs_to :restaurant
  belongs_to :user
  belongs_to :user_transaction
  has_many :order_items
  has_many :items, through: :order_items

  validates :user_id, presence: true
  validates :status, inclusion: { in: ['paid',
                                       'ready for preparation',
                                       'cancelled',
                                       'in preparation',
                                       'ready for delivery',
                                       'out for delivery',
                                       'completed'], 
                     message: "invalid order status."}


  default_scope { order('created_at DESC') }
  scope :paid,                  -> { where("status = ?", "paid") }
  scope :ready_for_preparation, -> { where("status = ?", "ready for preparation") }
  scope :cancelled,             -> { where("status = ?", "cancelled") }
  scope :in_preparation,        -> { where("status = ?", "in preparation") }
  scope :ready_for_delivery,    -> { where("status = ?", "ready for delivery") }
  scope :out_for_delivery,      -> { where("status = ?", "out for delivery") }
  scope :completed,             -> { where("status = ?", "completed") }
  
  def for_transaction(transaction_id)
    where(user_transaction_id: transaction_id)
  end
  
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

  def total_dollar_amount
    number_to_currency(total_price / 100.00)
  end

  def formatted_time(time_type)
    time_type.localtime.strftime("%I:%M%P on %a, %b %-d, %Y")
  end
  
  def formatted_status
    status.split.map {|w| w.capitalize! }.join(" ")
  end

  def updated?
    status == "completed" || status == "cancelled"
  end

  def order_total
    order_items.each.inject(0) { |sum, item| sum + item.line_item_price }
  end

  def paid?
    status == "paid"
  end

  def cancelable?
    status == "ready for preparation" || status == "paid"
  end

  def payable?
    status == "ordered"
  end
  
  def cancel
    if cancelable?
      self.status = "cancelled"
    end
  end
end

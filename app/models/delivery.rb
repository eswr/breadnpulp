# == Schema Information
#
# Table name: deliveries
#
#  id                 :integer          not null, primary key
#  delivery_date      :date
#  at                 :time
#  collect            :integer
#  user_id            :integer
#  address_id         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  delivery_status_id :integer          default(1)
#  payment_date       :date
#  payment_mode       :string
#  booking_no         :string
#  payment_status_id  :integer
#  subscription_id    :integer
#  despatch_id        :integer
#  drop_id            :integer
#  coupon_code        :string
#  rider_id           :integer
#  kitchen_id         :integer          default(1)
#

class Delivery < ActiveRecord::Base

  after_create :set_booking_no

  belongs_to :user, counter_cache: true
  belongs_to :address
  belongs_to :delivery_status
  belongs_to :payment_status
  belongs_to :subscription
  belongs_to :drop
  belongs_to :kitchen

  has_many :packs, dependent: :destroy
  has_many :menus, through: :packs
  has_many :kickerrs, through: :menus
  has_many :food_items, through: :kickerrs

  validates :delivery_date,		   presence: true
  validates :at,					       presence: true
  validates :address_id,			   presence: true

  accepts_nested_attributes_for :packs, reject_if: lambda { |attributes| attributes[:quantity].to_f < 1 },
                                        allow_destroy: true
  # accepts_nested_attributes_for :address, reject_if: lambda { |attributes| attributes[:full_address].nil? }

  def get_total_amount
  	total_amt = 0
  	self.packs.each do |pack|
  		total_amt += pack.get_unit_price * pack.quantity
  	end
  	total_amt
  end

  def get_b_no
    counter = Delivery.where(delivery_date: self.delivery_date).where.not(booking_no: nil).count + 1
    "MUM001#{self.delivery_date.strftime("%y%m%d")}#{counter}"
  end

  def Delivery.get_chef_view_rows(date)
    deliveries = Delivery.where(delivery_date: date, delivery_status_id: 2).order(at: :asc)
    times = {}
    deliveries.each do |delivery|
      delivery.packs.each do |pack|
        if !times[delivery.at]
          times[delivery.at] = {}
        end
        pack.menu.kickerr.food_items.each do |food_item|
          if times[delivery.at][food_item.name]
            times[delivery.at][food_item.name] += pack.quantity
          else
            times[delivery.at][food_item.name] = pack.quantity
          end
        end
      end
    end
    times
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << ["Id", "Date", "User Id", "Time", "Delivery Status", "Address Id"]
      all.each do |delivery|
        csv << [delivery.id, delivery.delivery_date, delivery.user_id, delivery.at, delivery.delivery_status.name, delivery.address_id]
      end
    end
  end

  def set_booking_no
    self.update_attribute :booking_no, self.get_b_no
  end

  def Delivery.set_drop(drop_id, delivery_ids)
    delivery_ids.each do |delivery_id|
      Delivery.find(delivery_id).update_attribute :drop_id, drop_id
    end
  end

  def confirm_and_send_sms
    update_attribute :delivery_status_id, 2
    Msg91.delay.send_sms(user.phone_number, user_confirmation_text)
    Msg91.delay.send_sms('8451930080', operator_confirmation_text)
  end

  def cancel_and_send_sms
    update_attribute :delivery_status_id, 8
    # Msg91.delay.send_sms(user.phone_number, "")
  end

  def despatch_and_send_sms
    update_attribute :delivery_status_id, 4
    Msg91.delay.send_sms(user.phone_number, user_despatch_text)
    Msg91.delay(run_at: 90.minutes.from_now).send_sms(user.phone_number, user_feedback_text)
  end

  def return_and_send_sms
    update_attribute :delivery_status_id, 7
    # Msg91.delay.send_sms(user.phone_number, get_user_text)
  end

  def delivery_and_send_sms
    update_attribute :delivery_status_id, 5
    # Msg91.delay.send_sms(user.phone_number, get_user_text)
  end

  def assign_rider_and_send_sms(rider_id)
    update_attribute :rider_id, rider_id
    Msg91.delay.send_sms("#{rider.phone_number}", rider_despatch_text) if rider.nil? == false
  end

  def rider
    return nil if rider_id.nil?
    rider = User.find rider_id
  end


  private

    def user_confirmation_text
      text = "Hi #{user.name.split(' ').first}! Your order for: "
      packs.each do |pack|
        text += "#{pack.menu.kickerr.name}(#{pack.menu.kickerr.kickerr_size}): #{pack.quantity}. "
      end
      text += "has been confirmed."
      return text
    end

    def user_feedback_text
      text = "Hi #{user.name.split(' ').first}! How was your meal from breadnpulp today? Kindly share your reviews @ bit.ly/1OGG7Iv - Team Breadnpulp"
    end

    def operator_confirmation_text
      text = "Order confirmed for #{user.name.split(' ').first}. "
      packs.each do |pack|
        text += "#{pack.menu.kickerr.name}(#{pack.menu.kickerr.kickerr_size}): #{pack.quantity}. "
      end
      text += "#{address.postal_address}. "
      text += "#{at}. "
      text += "http://www.breadnpulp.com/todays_orders"
    end

    def user_despatch_text
      text = "Hello #{user.name}! Your order has been despatched. "
      if payment_date == Time.zone.now.to_date && payment_status.name == "Payment Due" && payment_mode == "Cash on delivery"
        text += "Please pay Rs.#{get_total_amount} to the delivery boy."
      end
      return text
    end

    def rider_despatch_text
      text = "Order for #{user.name} - #{user.phone_number}. "
      text += "#{address.postal_address}. "
      packs.each do |pack|
        text += "#{pack.menu.kickerr.name}(#{pack.menu.kickerr.kickerr_size}): #{pack.quantity}. "
      end
      text += "#{at.strftime "%I:%M%p"}. "
      if payment_date == Time.zone.now.to_date && payment_status.name == "Payment Due" && payment_mode == "Cash on delivery"
        text += "Collect Rs.#{get_total_amount}"
      end
      return text
    end
end

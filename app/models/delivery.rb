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
#  delivery_status_id :integer
#  payment_date       :date
#  payment_mode       :string
#  booking_no         :string
#  payment_status_id  :integer
#  subscription_id    :integer
#  despatch_id        :integer
#  drop_id            :integer
#  coupon_code        :string
#

class Delivery < ActiveRecord::Base

  after_create :set_booking_no

  belongs_to :user, counter_cache: true
  belongs_to :address
  belongs_to :delivery_status
  belongs_to :payment_status
  belongs_to :subscription
  belongs_to :drop

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
  	total_amount = 0
  	self.packs.each do |pack|
  		total_amount += pack.get_unit_price * pack.quantity
  	end
  	total_amount
  end

  def get_b_no
    counter = Delivery.where(delivery_date: self.delivery_date).where.not(booking_no: nil).count + 1
    "MUM001#{self.delivery_date.strftime("%y%m%d")}#{counter}"
  end

  def Delivery.get_chef_view_rows
    deliveries = Delivery.where(delivery_date: Time.zone.today).order(at: :asc)
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
      csv << ["Id", "Date", "User Id", "Time", "Delivery Status Id", "Address Id"]
      all.each do |delivery|
        csv << [delivery.id, delivery.delivery_date, delivery.user_id, delivery.at, delivery.delivery_status_id, delivery.address_id]
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
end

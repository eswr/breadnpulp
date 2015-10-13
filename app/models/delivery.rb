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
#

class Delivery < ActiveRecord::Base

  belongs_to :user
  belongs_to :address
  belongs_to :delivery_status
  belongs_to :payment_status

  has_many :packs, dependent: :destroy
  has_many :menus, through: :packs

  validates :delivery_date,		   presence: true
  validates :at,					       presence: true
  validates :address_id,			   presence: true

  accepts_nested_attributes_for :packs, reject_if: lambda { |attributes| attributes[:quantity].to_f < 1 }

  def get_total_amount
  	total_amount = 0
  	self.packs.each do |pack|
  		total_amount += pack.get_unit_price * pack.quantity
  	end
  	total_amount
  end

  def get_b_no
    counter = Delivery.where(delivery_date: self.delivery_date).where.not("booking_no = NULL").count + 1
    "MUM001#{self.delivery_date.strftime("%y%m%d")}#{counter}"
  end

end

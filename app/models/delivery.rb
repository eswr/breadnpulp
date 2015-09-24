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
#

class Delivery < ActiveRecord::Base
  belongs_to :user
  belongs_to :address
  belongs_to :delivery_status

  has_many :packs
  has_many :menus, through: :packs

  accepts_nested_attributes_for :packs, reject_if: lambda { |attributes| attributes[:quantity].to_f < 1 }

end

# == Schema Information
#
# Table name: deliveries
#
#  id         :integer          not null, primary key
#  on         :date
#  at         :time
#  collect    :integer
#  user_id    :integer
#  address_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Delivery < ActiveRecord::Base
  belongs_to :user
  belongs_to :address
  belongs_to :delivery_status

  has_many :packs
  has_many :menus, through: :packs

end

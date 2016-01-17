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
#  kitchen_id         :integer
#

require 'test_helper'

class DeliveryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

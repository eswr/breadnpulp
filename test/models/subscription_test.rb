# == Schema Information
#
# Table name: subscriptions
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  at                :time
#  start_date        :date
#  address_id        :integer
#  veg_qty           :integer
#  egg_qty           :integer
#  non_veg_qty       :integer
#  payment_status_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  no_of_days        :integer
#

require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

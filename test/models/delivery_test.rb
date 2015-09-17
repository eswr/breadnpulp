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

require 'test_helper'

class DeliveryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

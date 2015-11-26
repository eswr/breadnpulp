# == Schema Information
#
# Table name: despatches
#
#  id               :integer          not null, primary key
#  despatch_number  :string
#  service_provider :string
#  external_id      :string
#  despatch_status  :string
#  user_id          :integer
#  address_id       :integer
#  order_type       :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  despatch_date    :date
#

require 'test_helper'

class DespatchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: drops
#
#  id           :integer          not null, primary key
#  despatch_id  :integer
#  expected_at  :time
#  completed_at :time
#  drop_date    :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  drop_address :string
#

require 'test_helper'

class DropTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: menus
#
#  id           :integer          not null, primary key
#  available_on :date
#  kickerr_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  price        :integer
#

require 'test_helper'

class MenuTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

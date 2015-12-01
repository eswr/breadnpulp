# == Schema Information
#
# Table name: kickerrs
#
#  id           :integer          not null, primary key
#  name         :string
#  price        :integer
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  veg_type     :string
#  kickerr_size :string
#

require 'test_helper'

class KickerrTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

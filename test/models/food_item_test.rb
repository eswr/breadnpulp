# == Schema Information
#
# Table name: food_items
#
#  id          :integer          not null, primary key
#  name        :string
#  course      :string
#  veg_non_egg :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class FoodItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

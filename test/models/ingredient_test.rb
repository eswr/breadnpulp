# == Schema Information
#
# Table name: ingredients
#
#  id              :integer          not null, primary key
#  raw_material_id :integer
#  food_item_id    :integer
#  quantity        :float
#  unit            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

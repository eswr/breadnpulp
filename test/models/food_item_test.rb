# == Schema Information
#
# Table name: food_items
#
#  id                 :integer          not null, primary key
#  name               :string
#  veg_non_egg        :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  course             :string
#  show_image         :boolean
#  production_cost    :integer
#

require 'test_helper'

class FoodItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

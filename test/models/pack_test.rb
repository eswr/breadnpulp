# == Schema Information
#
# Table name: packs
#
#  id          :integer          not null, primary key
#  quantity    :integer
#  menu_id     :integer
#  delivery_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class PackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

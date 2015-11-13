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

class Ingredient < ActiveRecord::Base
	belongs_to	:food_item
	belongs_to 	:raw_material
end

# == Schema Information
#
# Table name: raw_materials
#
#  id          :integer          not null, primary key
#  name        :string
#  veg_non_egg :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class RawMaterial < ActiveRecord::Base
	has_many	:ingredients
end

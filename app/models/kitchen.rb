# == Schema Information
#
# Table name: kitchens
#
#  id         :integer          not null, primary key
#  name       :string
#  address    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Kitchen < ActiveRecord::Base
	has_many :deliveries

	resourcify
end

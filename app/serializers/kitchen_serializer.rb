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

class KitchenSerializer < ActiveModel::Serializer
  attributes :id, :name, :address
end

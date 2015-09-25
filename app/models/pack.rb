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
#  unit_price  :integer
#

class Pack < ActiveRecord::Base
  belongs_to :menu
  belongs_to :delivery
  belongs_to :kickerr

  def get_unit_price
  	self.unit_price.nil? ? self.menu.get_price : self.unit_price
  end
end

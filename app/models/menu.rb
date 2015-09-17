# == Schema Information
#
# Table name: menus
#
#  id           :integer          not null, primary key
#  available_on :date
#  kickerr_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  price        :integer
#

class Menu < ActiveRecord::Base
  belongs_to :kickerr

  has_many :packs
  has_many :deliveries, through: :packs
end

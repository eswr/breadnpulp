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

  has_and_belongs_to_many :orders
end

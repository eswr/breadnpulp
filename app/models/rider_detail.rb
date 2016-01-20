# == Schema Information
#
# Table name: rider_details
#
#  id         :integer          not null, primary key
#  kitchen_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RiderDetail < ActiveRecord::Base

end

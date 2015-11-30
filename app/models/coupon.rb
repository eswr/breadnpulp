# == Schema Information
#
# Table name: coupons
#
#  id             :integer          not null, primary key
#  code           :string
#  original_price :integer
#  final_price    :integer
#  active         :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Coupon < ActiveRecord::Base
end

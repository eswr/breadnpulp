# == Schema Information
#
# Table name: drops
#
#  id           :integer          not null, primary key
#  despatch_id  :integer
#  expected_at  :time
#  completed_at :time
#  drop_date    :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  drop_address :string
#

class Drop < ActiveRecord::Base
	belongs_to :despatch
	belongs_to :address

	has_many :deliveries

	def Drop.set_despatch(despatch_id, drop_ids)
		drop_ids.each do |drop_id|
		  Drop.find(drop_id).update_attribute :despatch_id, despatch_id
		end
	end
end

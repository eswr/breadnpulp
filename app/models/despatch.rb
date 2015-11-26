# == Schema Information
#
# Table name: despatches
#
#  id               :integer          not null, primary key
#  despatch_number  :string
#  service_provider :string
#  external_id      :string
#  despatch_status  :string
#  user_id          :integer
#  address_id       :integer
#  order_type       :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  despatch_date    :date
#

class Despatch < ActiveRecord::Base

	after_create	:set_despatch_number

	has_many		:deliveries

	belongs_to 		:user
	belongs_to		:address

	private

		def set_despatch_number
			counter = Despatch.where(service_provider: service_provider).count
			update_attribute :despatch_number, "MUM001#{service_provider}#{counter}"
		end
end

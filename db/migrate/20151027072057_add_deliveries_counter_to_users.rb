class AddDeliveriesCounterToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :deliveries_count, :integer, default: 0
  	User.reset_column_information
  	User.all.each do |user|
  		user.update_attribute :deliveries_count, user.deliveries.length
  	end
  end
end

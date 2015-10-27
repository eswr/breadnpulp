class AddDeliveriesCounterToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :deliveries_count, :integer, default: 0
  	User.reset_column_information
  	User.all.each do |user|
  		User.reset_counters user.id, :deliveries
  	end
  end
end

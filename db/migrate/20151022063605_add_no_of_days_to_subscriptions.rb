class AddNoOfDaysToSubscriptions < ActiveRecord::Migration
  def change
  	remove_column 	:subscriptions, :end_date, :date
  	add_column		:subscriptions, :no_of_days, :integer
  end
end

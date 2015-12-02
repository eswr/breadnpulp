class AddCommentsToDespatches < ActiveRecord::Migration
  def change
  	add_column :despatches, :comment, :string
  end
end

class CreateDespatches < ActiveRecord::Migration
  def change
    create_table :despatches do |t|
      t.string :despatch_number
      t.string :service_provider
      t.string :external_id
      t.string :despatch_status
      t.integer :user_id
      t.integer :address_id
      t.string :order_type

      t.timestamps null: false
    end
  end
end

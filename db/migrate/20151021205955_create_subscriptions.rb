class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.time :at
      t.date :start_date
      t.date :end_date
      t.integer :address_id
      t.integer :veg_qty
      t.integer :egg_qty
      t.integer :non_veg_qty
      t.integer :payment_status_id

      t.timestamps null: false
    end
  end
end

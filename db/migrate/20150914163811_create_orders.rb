class CreateOrders < ActiveRecord::Migration
  def change

    create_table :order_statuses do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :orders do |t|
      t.date :delivery_on
      t.references :user, index: true, foreign_key: true
      t.references :address, index: true, foreign_key: true
      t.integer :total_amount
      t.references :order_status, index: true, foreign_key: true

      t.timestamps null: false
    end
    
  end
end

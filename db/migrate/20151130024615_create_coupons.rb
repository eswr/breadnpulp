class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.integer :original_price
      t.integer :final_price
      t.boolean :active

      t.timestamps null: false
    end
  end
end

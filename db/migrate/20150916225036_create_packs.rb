class CreatePacks < ActiveRecord::Migration
  def change
    create_table :packs do |t|
      t.integer :quantity
      t.references :menu, index: true, foreign_key: true
      t.references :delivery, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

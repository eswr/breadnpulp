class CreateDrops < ActiveRecord::Migration
  def change
    create_table :drops do |t|
      t.references :despatch, index: true, foreign_key: true
      t.references :address, index: true, foreign_key: true
      t.time :expected_at
      t.time :completed_at
      t.date :drop_date

      t.timestamps null: false
    end
  end
end

class CreateRiderDetails < ActiveRecord::Migration
  def change
    create_table :rider_details do |t|
      t.references :kitchen, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

class CreateFoodAlerts < ActiveRecord::Migration
  def change
    create_table :food_alerts do |t|
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end

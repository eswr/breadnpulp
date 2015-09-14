class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.date :available_on
      t.references :kickerr, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

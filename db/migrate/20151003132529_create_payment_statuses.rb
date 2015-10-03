class CreatePaymentStatuses < ActiveRecord::Migration
  def change
    create_table :payment_statuses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

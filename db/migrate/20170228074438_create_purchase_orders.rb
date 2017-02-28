class CreatePurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_orders do |t|
      t.datetime :purchase_date, null: false
      t.references :product, index: true

      t.timestamps
    end
  end
end

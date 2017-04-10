class CreatePurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_orders do |t|
      t.datetime :purchase_date, null: false
      t.integer :amount
      t.text :product_attributes, null: false
      t.string :provider_name, null: false

      t.timestamps
    end
  end
end

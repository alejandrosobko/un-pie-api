class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :brand
      t.string :article
      t.string :color
      t.text :description
      t.float :purchase_price, default: 0.0, null: false
      t.float :sale_price, default: 0.0, null: false
      t.float :cash_price, default: 0.0, null: false
      t.integer :size
      t.integer :amount, default: 0, null: false
      t.boolean :own, default: false
      t.references :provider, index: true

      t.timestamps
    end
  end
end

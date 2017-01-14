class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :brand
      t.string :article
      t.string :color
      t.text :description
      t.float :purchase_price
      t.float :sale_price
      t.float :cash_price
      t.integer :size
      t.integer :amount
      t.boolean :own, default: false
      t.references :provider, index: true

      t.timestamps
    end
  end
end

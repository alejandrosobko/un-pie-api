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
      t.string :size
      t.boolean :own, default: false

      t.timestamps
    end
  end
end

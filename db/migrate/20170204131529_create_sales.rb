class CreateSales < ActiveRecord::Migration[5.0]
  def change
    create_table :sales do |t|
      t.datetime :sale_date, null: false
      t.float :sale_price, null: false
      t.references :product, index: true
      t.references :provider, index: true

      t.timestamps
    end
  end
end

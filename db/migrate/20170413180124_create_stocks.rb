class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.integer :amount, default: 0, null: false
      t.belongs_to :product, index: true
      t.belongs_to :provider, index: true

      t.timestamps
    end
  end
end

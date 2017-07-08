class ChangeSalePriceToCreditCardPrice < ActiveRecord::Migration[5.0]
  def change
    rename_column :products, :sale_price, :credit_card_price
  end
end

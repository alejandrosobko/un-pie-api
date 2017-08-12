class AddProductToPurchaseOrder < ActiveRecord::Migration[5.0]
  def up
    add_column :purchase_orders, :product_id, :integer
    fix_previews_purchase_orders
    remove_column :purchase_orders, :product_attributes
  end

  def down
    add_column :purchase_orders, :product_attributes, :text
    fix_previews_purchase_orders_rollback
    remove_column :purchase_orders, :product_id
  end


  def fix_previews_purchase_orders
    PurchaseOrder.all.each do |po|
      product = Product.find(po.product_attributes['id'].to_i)
      po.product = product
      po.save!
    end
  end

  def fix_previews_purchase_orders_rollback
    PurchaseOrder.all.each do |po|
      po.product_attributes = po.product.attributes
      po.save!
    end
  end
end

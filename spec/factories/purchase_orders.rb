FactoryGirl.define do

  factory :purchase_order, class: PurchaseOrder do
    purchase_date DateTime.now.in_time_zone
    amount 5
    product_attributes {{brand: 'A brand'}}
  end

end

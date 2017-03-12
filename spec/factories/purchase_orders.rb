FactoryGirl.define do

  factory :purchase_order, class: PurchaseOrder do
    purchase_date DateTime.now.in_time_zone
    product
    provider
  end

end

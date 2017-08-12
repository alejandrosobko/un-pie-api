FactoryGirl.define do

  factory :purchase_order, class: PurchaseOrder do
    purchase_date DateTime.now.in_time_zone
    amount 5
    provider_name 'Ale'
  end

end

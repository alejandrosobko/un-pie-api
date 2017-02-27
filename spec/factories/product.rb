FactoryGirl.define do

  factory :product, class: Product do
    purchase_date Time.zone.now
  end

  factory :product_with_provider, class: Product do
    purchase_date Time.zone.now
    provider
  end

end
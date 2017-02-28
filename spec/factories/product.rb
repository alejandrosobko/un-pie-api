FactoryGirl.define do

  factory :product, class: Product do
    purchase_date Time.zone.now
    provider
  end

end
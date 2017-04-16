FactoryGirl.define do

  factory :sale, class: Sale do
    sale_date DateTime.now.in_time_zone
    sale_price 120
    product
    provider
  end

end

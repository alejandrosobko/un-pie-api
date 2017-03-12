FactoryGirl.define do

  factory :sale, class: Sale do

  end

  factory :complete_sale, class: Sale do
    sale_date DateTime.now.in_time_zone
    sale_price 120
    product
  end

end

FactoryGirl.define do

  factory :stock, class: Stock do
    product
    provider
    amount 5
  end

end

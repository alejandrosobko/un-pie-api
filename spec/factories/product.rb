FactoryGirl.define do

  factory :product, class: Product do

  end

  factory :product_with_provider, class: Product do
    provider
  end

end
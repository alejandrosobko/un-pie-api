FactoryGirl.define do

  factory :service, class: Service do
    name 'Gas'
    cost 120.5
    payment_date DateTime.now + 2.day
    due_date DateTime.now + 7.day
  end

end

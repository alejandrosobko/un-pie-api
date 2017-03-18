FactoryGirl.define do

  factory :user, class: User do
    name 'Alejandro'
    surname 'Sobko'
    email 'ale@mail.com'
    password 'Password10'
    password_confirmation 'Password10'
  end

end

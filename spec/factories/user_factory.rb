FactoryGirl.define do
  factory :user do
    after(:create) do |user, evaluator|
      create_list(:device, 1, user: user)
    end

    factory :full_user do
        email "test@test.com"
        username "test"
        password "Secure12345"
    end
  end
end

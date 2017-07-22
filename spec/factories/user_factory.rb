FactoryGirl.define do
  factory :user do
    after(:create) do |user, evaluator|
      create_list(:device, 1, user: user)
    end

    factory :full_user do
      sequence :email do |n|
        "test-#{n}@test.com"
      end
      sequence :username do |n|
        "test-#{n}"
      end
      password "Secure12345"
    end
  end

  factory :user_without_device, class: User do
  end
end

FactoryGirl.define do
  factory :device do
    platform :ios

    factory :device_with_push_token do
      push_token "1231232132132132131232132"
    end

    factory :device_with_user do
      transient do
        email    "test@test.com"
        username "test"
        password "Password123"
      end

      user do
        create  :user_without_device,
                email:    email,
                username: username,
                password: password
      end
    end
  end
end

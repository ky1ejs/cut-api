FactoryGirl.define do
  factory :device do
    platform :ios

    factory :device_with_push_token do
      push_token "1231232132132132131232132"
    end
  end
end

FactoryGirl.define do
  factory :follow do
    association :follower, factory: :full_user
    association :following, factory: :full_user
  end
end

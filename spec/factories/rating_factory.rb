FactoryGirl.define do
  factory :rating do
    source :rotten_tomatoes
    score 0.80
    association :film
  end
end

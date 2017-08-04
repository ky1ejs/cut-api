FactoryGirl.define do
  factory :watch do

    factory :rated_watch do
      rating 4
      comment "Pretty decent"
    end

    factory :unrated_watch do
    end
  end
end

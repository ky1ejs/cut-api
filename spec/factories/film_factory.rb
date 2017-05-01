FactoryGirl.define do
  factory :film do
    title "Test Film"

    factory :flixster_film do
      transient do
        provider { :flixster }
        provider_film_id { 1000 }
      end

      after(:create) do |film, evaluator|
        create_list(:film_provider, 1, provider: evaluator.provider, provider_film_id: evaluator.provider_film_id, film: film)
      end
    end
  end
end

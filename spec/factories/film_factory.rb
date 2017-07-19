FactoryGirl.define do
  factory :film do
    sequence :title do |n|
      "Test Film #{n}"
    end

    factory :film_with_posters do
      transient do
        poster_width { 61 }
        poster_height { 91 }
      end

      after(:create) do |film, evaluator|
        create_list(:poster, 1,
                    width: evaluator.poster_width,
                    height: evaluator.poster_height,
                    url: "http://resizing.flixster.com/rett=/#{evaluator.poster_width}x#{evaluator.poster_height}/123",
                    film: film)
      end
    end

    factory :flixster_film do
      transient do
        provider { :flixster }
        provider_film_id { 1000 }
      end

      after(:create) do |film, evaluator|
        create_list(:film_provider, 1, provider: evaluator.provider, provider_film_id: evaluator.provider_film_id, film: film)
      end

      factory :rotten_tomatoes_rated_film do
        transient do
          source { :rotten_tomatoes }
          score { 0.80 }
        end

        after(:create) do |film, evaluator|
          create_list(:rating, 1, source: evaluator.source, score: evaluator.score, film: film)
        end
      end
    end
  end
end

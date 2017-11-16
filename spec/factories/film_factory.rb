FactoryGirl.define do
  factory :film do
    theater_release_date  Date.today
    running_time          100
    synopsis              "Best film ever"

    sequence :title do |n|
      "Test Film #{n}"
    end

    transient do
      trailer_qualities     { [:low, :medium, :high, :hd] }
      poster_width  { 61 }
      poster_height { 91 }
    end

    after(:create) do |film, evaluator|
      evaluator.trailer_qualities.each do |q|
        create_list(:trailer, 1, quality: q, film: film)
      end

      create_list(:poster, 1,
                  width: evaluator.poster_width,
                  height: evaluator.poster_height,
                  url: "http://resizing.flixster.com/rett=/#{evaluator.poster_width}x#{evaluator.poster_height}/#{film.title}",
                  film: film)
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

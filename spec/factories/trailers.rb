FactoryGirl.define do
  factory :trailer do
    quality :hd
    duration 150

    sequence :url do |n|
      "url https://trailers.com/interstellar-#{n}.jpg"
    end

    sequence :preview_image_url do |n|
      "https://trailers.com/preview/interstellar-#{n}.jpg"
    end
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:title){ |n| "Movie #{n}" }
  sequence(:imdb_id){ |n| "tt#{n}" }

  factory :movie do
    title { generate(:title) }
    imdb_id { generate(:imdb_id) }
    tagline "Some tagline"
    plot "Plot summary"
    genres ["genre1", "genre2"]
    poster_url "http://movie.poster.com"
    trailer_url "http://movie.trailer.com"
    user
  end
end

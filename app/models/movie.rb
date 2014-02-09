class Movie < ActiveRecord::Base
  belongs_to :user

  serialize :genres, Array

  validates :imdb_id, presence: true, uniqueness: true

  before_save :get_data_from_imdb

private

  def get_data_from_imdb
    imdb_movie = IMDB.find_movie_by_id(self.imdb_id)
    data       = imdb_movie_to_attributes(imdb_movie)
    assign_attributes(data)
  end

  def imdb_movie_to_attributes(imdb_movie)
    {
      title:        imdb_movie.title,
      tagline:      imdb_movie.tagline,
      plot:         imdb_movie.plot,
      genres:       imdb_movie.genres,
      poster_url:   imdb_movie.poster_url,
      trailer_url:  imdb_movie.trailers.try(:first).try(:last),
      year:         imdb_movie.release_date.try(:to_date).try(:year),
    }
  end

end

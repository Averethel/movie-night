class Movie < ActiveRecord::Base
  belongs_to :user

  serialize :genres, Array

  validates :title, presence: :true, if: ->(m){ m.current_step == 'set_title' }
  validates :imdb_id, presence: true, if: ->(m){ m.current_step == 'choose_from_imdb' }
  validates :imdb_id, uniqueness: true, if: ->(m){ m.imdb_id.present? }

  before_save :get_data_from_imdb, if: ->(m){ m.title.nil? }

  attr_writer :current_step

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[set_title choose_from_imdb]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1] unless last_step?
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1] unless first_step?
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def imdb_link
    "http://www.imdb.com/title/#{self.imdb_id}/"
  end

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

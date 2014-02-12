class MoviesController < ApplicationController
  skip_before_filter :reset_session, only: [:create]

  def index
    @movies = Movie.all
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new movie_params
    @movie.current_step = session[:movie_step]

    save_or_next_step
    redirect_or_render
  end

private

  def movie_params
    params.require(:movie).permit(:title, :imdb_id)
  end

  def save_or_next_step
    if @movie.valid?
      if @movie.last_step?
        @movie.user = current_user
        @movie.save
      else
        session[:movie_step] = @movie.next_step
      end
    end
  end

  def redirect_or_render
    if @movie.new_record?
      @movies = IMDB.find_by_title(@movie.title) if @movie.current_step == 'choose_from_imdb'
      render :new
    else
      session[:movie_step] = nil
      redirect_to action: :index
    end
  end

end

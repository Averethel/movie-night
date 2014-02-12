module Movies
  class IndexPage < CapybaraPage
    def open
      visit movies_path
    end

    def movies
      find(".movies")
    end

    def movie_row(movie)
      within(movies) do
        find("#movie-#{movie.id}")
      end
    end

    def open_details_for(movie)
      within(movie_row(movie)) do
        click_link("More")
      end
    end

    def details_popup_for(movie)
      find("#movie-info-#{movie.id}")
    end
  end
end

module Movies
  class NewPage < CapybaraPage
    def open
      visit new_movie_path
    end

    def form
      find("#new_movie")
    end

    def fill_title(title)
      within(form) do
        fill_in "Title", with: title
        click_button "Continue"
      end
    end

    def suggestions
      find("#imdb-suggestions")
    end

    def choose_suggestion(imdb_id)
      within(suggestions) do
        within("##{imdb_id}") do
          click_button("Add")
        end
      end
    end
  end
end

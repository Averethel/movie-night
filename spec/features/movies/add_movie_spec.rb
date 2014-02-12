require "spec_helper"

feature "Adding movie" do
  let(:new_page) { Movies::NewPage.new }
  let(:index_page) { Movies::IndexPage.new }

  let(:imdb_id) { "tt0468570" }
  let(:imdb_movies) {[
    {
      title: "The Dark Knight",
      year: ["2008"],
      imdb_id: imdb_id
    }
  ]}
  let(:imdb_movie) { double(ImdbParty::Movie,
      imdb_id: imdb_id,
      title: "The Dark Knight",
      tagline: "Why So Serious?",
      plot: "When Batman, Gordon and Harvey Dent launch an assault on the mob, they let the clown out of the box, the Joker, bent on turning Gotham on itself and bringing any heroes down to his level.",
      runtime: "152 min",
      rating: 9,
      poster_url: "http://ia.media-imdb.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_.jpg",
      release_date: "2008-07-18",
      certification: "PG-13",
      genres: ["Action", "Crime", "Drama", "Thriller"],
      trailer_url: "http://ia.media-imdb.com/images/M/MV5BOTE4NTY5MzUyMF5BMl5BanBnXkFtZTcwNDc1MjIwMg@@._V1_.jpg",
      trailers: {
        "H.264 480x270"=>"http://www.totaleclips.com/Player/Bounce.aspx?eclipid=e43433&bitrateid=461&vendorid=102&type=.mp4",
        "H.264 640x360"=>"http://www.totaleclips.com/Player/Bounce.aspx?eclipid=e43433&bitrateid=472&vendorid=102&type=.mp4"
      }
    )
  }

  before :all do
    @user  = create(:user)
  end

  background do
    ApplicationController.any_instance.stub(:current_user).and_return(@user)
    IMDB.stub(:find_by_title).with("The Dark Knight").and_return(imdb_movies)
    IMDB.stub(:find_movie_by_id).with(imdb_id).and_return(imdb_movie)

    new_page.open
  end

  it "displays suggestions from imdb" do
    new_page.fill_title("The Dark Knight")

    imdb_movies.each do |m|
      expect(new_page.suggestions).to have_content(m[:title])
    end
  end

  it "ads a movie" do
    new_page.fill_title("The Dark Knight")
    new_page.choose_suggestion(imdb_movies.first[:imdb_id])

    index_page.open
    expect(index_page.movies).to have_content("The Dark Knight")
  end
end

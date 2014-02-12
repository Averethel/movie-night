require 'spec_helper'

describe MoviesController do
  before :each do
    MoviesController.any_instance.stub(:current_user).and_return(build(:user))
  end

  describe "GET index" do
    before :each do
      @movie1 = create(:movie)
      @movie2 = create(:movie)

      get :index
    end

    it "returns http success" do
      response.should be_success
    end

    it "assigns movies" do
      assigns(:movies).should eq([@movie1, @movie2])
    end
  end

  describe "GET new" do
    before :each do
      get :new
    end

    it "returns http success" do
      response.should be_success
    end

    it "assigns movie" do
      assigns(:movie).should be_a(Movie)
      assigns(:movie).should be_new_record
    end
  end

  describe "POST create" do
    context "during set_title step" do
      context "with invalid params" do
        let(:params){ {movie: {title: nil}} }

        before :each do
          Movie.any_instance.should_receive(:valid?).once.and_return(false)
        end

        it "returns http success" do
          post :create, params

          response.should be_success
        end

        it "assigns movie" do
          post :create, params

          assigns(:movie).should be_a(Movie)
          assigns(:movie).should be_new_record
        end

        it "checks if movie is valid" do
          post :create, params
        end

        it "does not change session movie_step" do
          lambda {
            post :create, params
          }.should_not change{ session[:movie_step] }
        end
      end

      context "with valid params" do
        let(:params){ {movie: {title: "This is a test title"}} }

        before :each do
          IMDB.stub(:find_by_title)
          Movie.any_instance.should_receive(:valid?).once.and_return(true)
        end

        it "returns http success" do
          post :create, params

          response.should be_success
        end

        it "assigns movie" do
          post :create, params

          assigns(:movie).should be_a(Movie)
          assigns(:movie).should be_new_record
        end

        it "checks if movie is valid" do
          post :create, params
        end

        it "calls next_step on a movie" do
          Movie.any_instance.should_receive(:next_step)

          post :create, params
        end

        it "changes session movie_step" do
          lambda {
            post :create, params
          }.should change{ session[:movie_step] }
        end

        it "searches for movies in IMDB" do
          IMDB.should_receive(:find_by_title).with(params[:movie][:title]).once

          post :create, params
        end
      end
    end

    context "during select_from_imdb step" do
      context "with invalid params" do
        let(:params){ {movie: {imdb_id: nil}} }

        before :each do
          Movie.any_instance.should_receive(:valid?).once.and_return(false)
        end

        it "returns http success" do
          post :create, params

          response.should be_success
        end

        it "assigns movie" do
          post :create, params

          assigns(:movie).should be_a(Movie)
          assigns(:movie).should be_new_record
        end

        it "checks if movie is valid" do
          post :create, params
        end

        it "does not change session movie_step" do
          lambda {
            post :create, params
          }.should_not change{ session[:movie_step] }
        end
      end

      context "with valid params" do
        let(:imdb_id) { "tt0468569" }
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
        let(:params){ {movie: {imdb_id: imdb_id}} }

        before :each do
          session[:movie_step] = "choose_from_imdb"
          # once for check and once for save
          Movie.any_instance.should_receive(:valid?).twice.and_return(true)
          IMDB.should_receive(:find_movie_by_id).with(imdb_id).once.and_return(imdb_movie)
        end

        it "redirect to index" do
          post :create, params

          response.should redirect_to(movies_path)
        end

        it "assigns movie" do
          post :create, params

          assigns(:movie).should be_a(Movie)
          assigns(:movie).should be_persisted
        end

        it "checks if movie is valid" do
          post :create, params
        end

        it "resets session movie_step" do
          lambda {
            post :create, params
          }.should change{ session[:movie_step] }.to(nil)
        end

        it "sets the user" do
          Movie.any_instance.should_receive(:user=)

          post :create, params
        end
      end
    end
  end
end

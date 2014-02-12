require 'spec_helper'

describe Movie do
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
  let(:attributes) {
    {
      title:        imdb_movie.title,
      tagline:      imdb_movie.tagline,
      plot:         imdb_movie.plot,
      genres:       imdb_movie.genres,
      poster_url:   imdb_movie.poster_url,
      trailer_url:  imdb_movie.trailers.first.last,
      year:         imdb_movie.release_date.to_date.year,
    }
  }

  its(:steps){ should eq(["set_title", "choose_from_imdb"])}

  context "(first step)" do
    it { should validate_presence_of :title }

    its(:current_step){ should eq("set_title") }
    its(:next_step){ should eq("choose_from_imdb") }
    its(:previous_step){ should be_nil }
    it { should be_first_step }
    it { should_not be_last_step }
  end

  context "(second step)" do
    before :each do
      subject.next_step
    end

    it { should validate_presence_of :imdb_id }
    it {
      Movie.any_instance.stub(:get_data_from_imdb).and_return(:imdb_movie)
      should validate_uniqueness_of :imdb_id
    }

    its(:current_step){ should eq("choose_from_imdb") }
    its(:next_step){ should be_nil }
    its(:previous_step){ should eq("set_title") }
    it { should_not be_first_step }
    it { should be_last_step }
  end

  describe '#imdb_movie_to_attributes' do
    let(:movie) { build(:movie, imdb_id: imdb_id, title: nil ) }

    subject { movie.send(:imdb_movie_to_attributes, imdb_movie) }

    its([:title]) { should eq imdb_movie.title }
    its([:tagline]) { should eq imdb_movie.tagline }
    its([:plot]) { should eq imdb_movie.plot }
    its([:genres]) { should eq imdb_movie.genres }
    its([:poster_url]) { should eq imdb_movie.poster_url }
    its([:trailer_url]) { should eq imdb_movie.trailers.first.last }
    its([:year]) { should eq imdb_movie.release_date.to_date.year }
  end

  describe '#get_data_from_imdb' do
    subject { build(:movie, imdb_id: imdb_id, title: nil ) }

    before :each do
      IMDB.should_receive(:find_movie_by_id).with(imdb_id).once.and_return(imdb_movie)
    end

    it "queries imdb for movie data" do
      subject.send(:get_data_from_imdb)
    end

    it "converts imdb movie data to attributes hash" do
      subject.should_receive(:imdb_movie_to_attributes).with(imdb_movie).and_call_original

      subject.send(:get_data_from_imdb)
    end

    it "sets the attributes" do
      subject.should_receive(:imdb_movie_to_attributes).with(imdb_movie).and_return(attributes)
      subject.should_receive(:assign_attributes).with(attributes).and_call_original
      subject.send(:get_data_from_imdb)
    end

    it "is called on save" do
      subject.next_step
      subject.save
    end
  end
end

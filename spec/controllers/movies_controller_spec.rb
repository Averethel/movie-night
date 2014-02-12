require 'spec_helper'

describe MoviesController do
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
end

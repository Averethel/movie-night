require "spec_helper"

feature "Movie details popup", js: true do
  let(:index_page) { Movies::IndexPage.new }

  before :all do
    @user  = create(:user)
    @movie = create(:movie, user: @user)
  end

  background do
    ApplicationController.any_instance.stub(:current_user).and_return(@user)

    index_page.open
    index_page.open_details_for(@movie)
  end

  scenario "includes movie title" do
    expect(index_page.details_popup_for(@movie)).to have_content(@movie.title)
  end

  scenario "includes movie year" do
    expect(index_page.details_popup_for(@movie)).to have_content(@movie.year)
  end

  scenario "includes movie tagline" do
    expect(index_page.details_popup_for(@movie)).to have_content(@movie.tagline)
  end

  scenario "includes movie plot" do
    expect(index_page.details_popup_for(@movie)).to have_content(@movie.plot)
  end

  scenario "includes movie genres" do
    expect(index_page.details_popup_for(@movie)).to have_content(@movie.genres.join(", "))
  end

  scenario "includes movie poster" do
    expect(index_page.details_popup_for(@movie)).to have_css("img.poster")
  end

  scenario "includes movie trailer" do
    within(index_page.details_popup_for(@movie)) do
      click_link "Trailer"
    end

    expect(index_page.details_popup_for(@movie)).to have_css("video.trailer")
  end
end

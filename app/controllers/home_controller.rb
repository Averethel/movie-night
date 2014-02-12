class HomeController < ApplicationController
  def index
    authorize! :index, :home
  end
end

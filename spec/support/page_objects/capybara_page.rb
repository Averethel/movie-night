require 'spec_helper'

class CapybaraPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def open
    raise 'no path for visit set'
  end

  def save_and_open
    save_and_open_page
  end
end

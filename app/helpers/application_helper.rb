module ApplicationHelper
  def imdb_link_for(imdb_id)
    "http://www.imdb.com/title/#{imdb_id}/"
  end
end

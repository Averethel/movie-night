class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :imdb_id
      t.string :tagline
      t.text :plot
      t.text :genres
      t.string :poster_url
      t.string :trailer_url
      t.integer :year
      t.references :user, index: true

      t.timestamps
    end
  end
end

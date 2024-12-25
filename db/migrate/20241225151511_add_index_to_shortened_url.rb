class AddIndexToShortenedUrl < ActiveRecord::Migration[8.0]
  def change
    add_index :urls, :shortened_url, unique: true
  end
end

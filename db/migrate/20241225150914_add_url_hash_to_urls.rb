class AddUrlHashToUrls < ActiveRecord::Migration[8.0]
  def change
    add_column :urls, :url_hash, :string
    add_index :urls, :url_hash, unique: true
  end
end

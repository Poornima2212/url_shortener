class AddUserToUrl < ActiveRecord::Migration[8.0]
  def self.up
    change_table :urls do |t|
      t.references :user, null: false, foreign_key: true
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :user
    end
  end
end

class AddEncryptedEmailToUsers < ActiveRecord::Migration[8.0]
  def self.up
    change_table :users do |t|
      t.add_column :users, encrypted_email, :string
    end
  end

  def self.down
    change_table :users do |t|
      t.remove_column ::users, encrypted_email, :string
    end
  end
end

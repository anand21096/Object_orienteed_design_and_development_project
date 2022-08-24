class AddKeysToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phone_no, :string
    add_column :users, :department, :string
    add_column :users, :date_of_birth, :string
    add_column :users, :major, :string
  end
end

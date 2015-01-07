class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token, :string, default: ""
    add_column :users, :username, :string, default: ""
    add_column :users, :facebook_id, :string, null: true, default: ''
    add_column :users, :first_name, :string, default: ""
    add_column :users, :last_name, :string, default: ""

    add_index :users, :authentication_token, unique: true
    add_index :users, :username, unique: false
    add_index :users, :facebook_id, unique: false
  end
end

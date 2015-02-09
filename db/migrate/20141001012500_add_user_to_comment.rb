class AddUserToComment < ActiveRecord::Migration
  def change
    add_column :comments, :user, :reference
  end
end

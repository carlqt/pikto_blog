class AddTypeToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :type, :string
  end
end

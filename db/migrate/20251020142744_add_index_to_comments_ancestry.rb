class AddIndexToCommentsAncestry < ActiveRecord::Migration[8.0]
  def change
    add_index :comments, :ancestry
  end
end

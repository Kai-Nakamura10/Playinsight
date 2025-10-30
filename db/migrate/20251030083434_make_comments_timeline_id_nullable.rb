class MakeCommentsTimelineIdNullable < ActiveRecord::Migration[8.0]
  def up
    change_column_null :comments, :timeline_id, true
  end

  def down
    change_column_null :comments, :timeline_id, false
  end
end

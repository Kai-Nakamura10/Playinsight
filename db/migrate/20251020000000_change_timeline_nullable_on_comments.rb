class ChangeTimelineNullableOnComments < ActiveRecord::Migration[8.0]
  def change
    change_column_null :comments, :timeline_id, true
  end
end

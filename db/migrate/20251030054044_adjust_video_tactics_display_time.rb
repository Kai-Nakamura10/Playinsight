# rails g migration AdjustVideoTacticsDisplayTime
class AdjustVideoTacticsDisplayTime < ActiveRecord::Migration[8.0]
  def up
    change_column :video_tactics, :display_time, :decimal, precision: 8, scale: 2, null: false, default: 0
    remove_index :video_tactics, column: [ :video_id, :tactic_id ]
    add_index :video_tactics, [ :video_id, :tactic_id, :display_time ], unique: true
    add_index :video_tactics, [ :video_id, :display_time ]
  end

  def down
    remove_index :video_tactics, column: [ :video_id, :display_time ]
    remove_index :video_tactics, column: [ :video_id, :tactic_id, :display_time ]
    add_index    :video_tactics, [ :video_id, :tactic_id ], unique: true
    change_column :video_tactics, :display_time, :integer, null: true, default: nil
  end
end

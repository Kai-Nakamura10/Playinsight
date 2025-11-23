class CreateVideoTactics < ActiveRecord::Migration[8.0]
  def change
    create_table :video_tactics do |t|
      t.references :video, type: :uuid, null: false, foreign_key: true
      t.references :tactic, type: :uuid, null: false, foreign_key: true
      t.integer :display_time

      t.timestamps
    end
    add_index :video_tactics, [ :video_id, :tactic_id ], unique: true
  end
end

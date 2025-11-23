class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :video, type: :uuid, null: false, foreign_key: true
      t.references :timeline, null: false, foreign_key: true
      t.decimal :video_timestamp_seconds, precision: 8, scale: 2
      t.text :body
      t.string :ancestry

      t.timestamps
    end
  end
end

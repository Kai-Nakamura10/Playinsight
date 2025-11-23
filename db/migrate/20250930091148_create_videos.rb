class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :title, null: false
      t.text    :description
      t.integer :duration_seconds
      t.string :visibility, null: false, default: "unlisted"
      t.timestamps
    end
  end
end

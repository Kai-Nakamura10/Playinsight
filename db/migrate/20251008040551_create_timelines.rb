class CreateTimelines < ActiveRecord::Migration[8.0]
  def change
    create_table :timelines do |t|
      t.references :video, type: :uuid, null: false, foreign_key: true
      t.string :kind, index: true
      t.decimal :start_seconds, precision: 8, scale: 2, null: false
      t.decimal :end_seconds, precision: 8, scale: 2
      t.string :title
      t.text :body
      t.jsonb :payload, default: {}

      t.timestamps
    end
  end
end

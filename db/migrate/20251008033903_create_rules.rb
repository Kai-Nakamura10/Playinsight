class CreateRules < ActiveRecord::Migration[8.0]
  def change
    create_table :rules, id: :uuid do |t|
      t.string :title, null: false
      t.text :body
      t.string :slug, null: false, index: { unique: true }
      t.string :youtube_url
      t.jsonb :aliases, default: []
      t.timestamps
    end
  end
end

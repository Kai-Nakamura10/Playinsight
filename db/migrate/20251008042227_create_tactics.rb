class CreateTactics < ActiveRecord::Migration[8.0]
  def change
    create_table :tactics, id: :uuid do |t|
      t.string :title
      t.text :description
      t.string :trigger
      t.jsonb :steps
      t.string :counters
      t.string :slug

      t.timestamps
    end
  end
end

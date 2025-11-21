class CreateFailurePatterns < ActiveRecord::Migration[8.0]
  def change
    create_table :failure_patterns do |t|
      t.references :tactic, type: :uuid, null: false, foreign_key: true
      t.string :body

      t.timestamps
    end
  end
end

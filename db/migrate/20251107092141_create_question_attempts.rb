class CreateQuestionAttempts < ActiveRecord::Migration[8.0]
  def change
    create_table :question_attempts do |t|
      t.references :question, null: false, foreign_key: true
      t.references :choice, null: false, foreign_key: true
      t.boolean :is_correct,      null: false, default: false
      t.jsonb   :explanation_json, null: false, default: {}
      t.string :ai_model_name
      t.integer :latency_ms

      t.timestamps
    end
    add_index :question_attempts, [ :question_id, :choice_id ]
    add_index :question_attempts, :created_at
  end
end

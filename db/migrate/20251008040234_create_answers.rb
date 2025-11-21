class CreateAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :answers do |t|
      t.references :bestselect, type: :uuid, null: false, foreign_key: true
      t.text :body
      t.boolean :is_correct, null: false, default: false
      t.integer :position

      t.timestamps
    end
  end
end

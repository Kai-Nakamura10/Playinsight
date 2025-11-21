class CreateChoices < ActiveRecord::Migration[8.0]
  def change
    create_table :choices do |t|
      t.references :question, type: :uuid, null: false, foreign_key: true
      t.text :body, null: false
      t.boolean :is_correct, null: false, default: false
      t.timestamps
    end
  end
end

class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions, id: :uuid do |t|
      t.text :content, null: false
      t.text :explanation
      t.timestamps
    end
  end
end

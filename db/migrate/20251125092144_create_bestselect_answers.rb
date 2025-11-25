class CreateBestselectAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :bestselect_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bestselect, type: :uuid, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true
      t.boolean :is_correct

      t.timestamps
    end
  end
end

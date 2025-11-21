class CreateFaqsAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :faqs_answers do |t|
      t.references :faq, type: :uuid, null: false, foreign_key: true
      t.string :body

      t.timestamps
    end
  end
end

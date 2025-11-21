class CreateFaqs < ActiveRecord::Migration[8.0]
  def change
    create_table :faqs, id: :uuid do |t|
      t.string :body
      t.string :category
      t.integer :order
      t.timestamps
    end
  end
end

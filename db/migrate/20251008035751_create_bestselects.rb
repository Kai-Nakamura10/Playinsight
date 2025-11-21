class CreateBestselects < ActiveRecord::Migration[8.0]
  def change
    create_table :bestselects, id: :uuid do |t|
      t.text :question, null: false
      t.text :explanation
      t.timestamps
    end
  end
end

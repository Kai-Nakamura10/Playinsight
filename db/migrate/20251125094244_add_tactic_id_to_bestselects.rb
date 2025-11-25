class AddTacticIdToBestselects < ActiveRecord::Migration[8.0]
  def change
    add_reference :bestselects, :tactic, type: :uuid, null: true, foreign_key: true
  end
end

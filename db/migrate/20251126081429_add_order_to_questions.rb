class AddOrderToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :order, :integer
  end
end

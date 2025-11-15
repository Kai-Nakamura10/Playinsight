class SuccessCondition < ApplicationRecord
  belongs_to :tactic
  validates :body, length: { maximum: 100 }
end

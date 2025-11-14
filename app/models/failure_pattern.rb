class FailurePattern < ApplicationRecord
  belongs_to :tactic
  has_many :videos, dependent: :nullify
  validates :body, length: { maximum: 100 }
end

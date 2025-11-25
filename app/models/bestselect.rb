class Bestselect < ApplicationRecord
  belongs_to :tactic, optional: true
  has_many :answers, dependent: :destroy
  validates :question, presence: true
  validates :explanation, presence: true
  accepts_nested_attributes_for :answers, allow_destroy: true, reject_if: :all_blank
end

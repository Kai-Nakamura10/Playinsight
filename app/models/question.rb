class Question < ApplicationRecord
  has_many :choices, dependent: :destroy
  validates :content, presence: true
  validates :explanation, presence: true
  accepts_nested_attributes_for :choices, allow_destroy: true, reject_if: :all_blank
  def next
    ordered_ids = Question.ordered.pluck(:id)
    current_index = ordered_ids.index(id)
    return nil unless current_index

    next_id = ordered_ids[current_index + 1]
    next_id ? Question.find(next_id) : nil
  end

  scope :ordered, -> { order(:order, :created_at, :id) }
  def self.first_question
    ordered.first
  end
end

class Question < ApplicationRecord
  has_many :choices, dependent: :destroy
  validates :content, presence: true
  validates :explanation, presence: true
  accepts_nested_attributes_for :choices, allow_destroy: true, reject_if: :all_blank
  def next
    Question.where("created_at > ?", created_at).order(:created_at).first
  end
end

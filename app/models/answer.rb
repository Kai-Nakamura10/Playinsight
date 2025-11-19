class Answer < ApplicationRecord
  belongs_to :bestselect
  validates :body, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :is_correct, inclusion: { in: [ true, false ] }
  default_scope { order(:position) }
  before_validation :set_position, on: :create
  private
  def set_position
    if self.position.nil?
      max_position = bestselect.answers.maximum(:position) || 0
      self.position = max_position + 1
    end
  end
end

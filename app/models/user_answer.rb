class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :bestselect
  belongs_to :answer

  validates :is_correct, inclusion: { in: [ true, false ] }

  # 重複防止する場合
  validates :bestselect_id, uniqueness: { scope: :user_id }

  # スコープ（便利メソッド）
  scope :correct, -> { where(is_correct: true) }
  scope :incorrect, -> { where(is_correct: false) }

  # 回答がセットされたら自動で is_correct を決定する
  before_validation :set_is_correct_from_answer, if: -> { answer.present? }

  private

  def set_is_correct_from_answer
    # answer.is_correct が nil でないことを想定
    self.is_correct = answer.is_correct
  end
end

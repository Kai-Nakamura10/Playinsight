class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :nickname, presence: true, uniqueness: true, length: { maximum: 10 }
  has_many :videos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :user_answers, dependent: :destroy

  def correct_answers_count
    user_answers.where(is_correct: true).count
  end

  def total_answers_count
    user_answers.count
  end

  def accuracy_rate
    return 0 if total_answers_count.zero?
    (correct_answers_count.to_f / total_answers_count * 100).round(1)
  end
end

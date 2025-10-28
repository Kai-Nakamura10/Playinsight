class Faq < ApplicationRecord
  has_many :faqs_answers, dependent: :destroy
  validates :body, presence: true, uniqueness: true
end

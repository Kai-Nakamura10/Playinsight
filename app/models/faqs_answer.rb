class FaqsAnswer < ApplicationRecord
  belongs_to :faq
  validates :body, presence: true
end

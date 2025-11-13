class Rule < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :title, length: { maximum: 100 }
  validates :body, length: { maximum: 400 }
end

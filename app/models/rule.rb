class Rule < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
end

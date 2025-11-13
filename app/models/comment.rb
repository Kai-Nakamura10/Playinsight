class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :video
  belongs_to :timeline, optional: true
  has_ancestry
  validates :body, presence: true
  validates :body, length: { maximum: 500 }

  default_scope { order(created_at: :asc) }

  def to_s
    body.truncate(30)
  end

  def formatted_created_at
    created_at.strftime("%Y-%m-%d %H:%M")
  end
end

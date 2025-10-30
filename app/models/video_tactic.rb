class VideoTactic < ApplicationRecord
  belongs_to :video
  belongs_to :tactic

  validates :display_time, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

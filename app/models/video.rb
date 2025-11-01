class Video < ApplicationRecord
  belongs_to :user
  has_many :video_tactics, dependent: :destroy
  has_many :timelines, dependent: :destroy
  has_many :tactics, through: :video_tactics
  has_many :video_tags, dependent: :destroy
  has_many :tags, through: :video_tags
  has_many :comments, dependent: :destroy
  has_one_attached :file
  has_one_attached :thumbnail

  attribute :visibility, :string
  enum :visibility, { public: "public", unlisted: "unlisted", private: "private" }, prefix: true, scopes: false
  validates :title, presence: true
  validates :visibility, inclusion: { in: %w[public unlisted private] }
  validates :duration_seconds, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  after_commit :enqueue_video_job, on: :create

  private

  def enqueue_processing
    VideoJob.perform_later(id)
  end
end

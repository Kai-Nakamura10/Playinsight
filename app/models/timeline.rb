class Timeline < ApplicationRecord
  belongs_to :video

  KINDS = %w[question bestselect].freeze

  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :start_seconds, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :end_seconds, numericality: { greater_than_or_equal_to: :start_seconds }, allow_blank: true

  validate :title_or_body_present
  validate :payload_is_hash

  scope :order_by_time, -> { order(:start_seconds) }

  before_validation :ensure_payload_hash

  def to_s
    title.presence || "#{kind} at #{start_seconds}s"
  end

  scope :hit_at, ->(t) {
    where("COALESCE(end_seconds, start_seconds) >= ? AND start_seconds <= ?", t, t)
  }

  private

  def title_or_body_present
    if title.blank? && body.blank?
      errors.add(:base, "タイトルまたは本文のいずれかを入力してください")
    end
  end

  def ensure_payload_hash
    self.payload = {} unless payload.is_a?(Hash)
  end

  def payload_is_hash
    errors.add(:payload, "must be a JSON object") unless payload.is_a?(Hash)
  end
end

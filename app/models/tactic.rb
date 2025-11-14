class Tactic < ApplicationRecord
  attr_accessor :success_text, :failure_text, :counters_text
  has_many :video_tactics, dependent: :destroy
  has_many :videos, through: :video_tactics
  has_many :success_conditions, dependent: :destroy
  has_many :failure_patterns, dependent: :destroy
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  # Ensure text accessor fields are reflected into JSON columns before validation
  before_validation :apply_text_fields_to_steps_and_counters

  def success_conditions
    (steps.is_a?(Hash) ? steps["success_conditions"] : nil) || []
  end

  def common_failures
    (steps.is_a?(Hash) ? steps["common_failures"] : nil) || []
  end

  def counters_string
    counters.to_s
  end

  private

  def apply_text_fields_to_steps_and_counters
    self.steps ||= {}
    if success_text.present?
      self.steps["success_conditions"] =
        success_text.to_s.lines.map { _1.strip }.reject(&:blank?)
    else
      self.steps["success_conditions"] = Array(self.steps["success_conditions"]).compact_blank
    end
    if failure_text.present?
      self.steps["common_failures"] =
        failure_text.to_s.lines.map { _1.strip }.reject(&:blank?)
    else
      self.steps["common_failures"] = Array(self.steps["common_failures"]).compact_blank
    end
    if counters_text.present?
      self.counters = counters_text.to_s.strip
    end
  end
end

class Tag < ApplicationRecord
  has_many :video_tags, dependent: :destroy
  has_many :videos, through: :video_tags
  before_validation :strip_name
  FULLWIDTH_ALNUM_REGEX = /[Ａ-Ｚａ-ｚ０-９\u3000]/.freeze
  validates :name, presence: true, uniqueness: { case_sensitive: false }, format: { without: FULLWIDTH_ALNUM_REGEX, message: "に全角英数字は使用できません（半角で入力してください）" }

  private

  def strip_name
    return if name.nil?
    self.name = name.strip
  end
end

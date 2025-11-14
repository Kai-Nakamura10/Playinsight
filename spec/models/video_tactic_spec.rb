require 'rails_helper'

RSpec.describe VideoTactic, type: :model do
  let(:video) { create(:video) }
  let(:tactic) { create(:tactic) }

  describe "バリデーション" do
    it "video・tactic・display_time があれば有効" do
      video_tactic = build(:video_tactic, video: video, tactic: tactic, display_time: 12.5)
      expect(video_tactic).to be_valid
    end

    it "display_time が空だと無効" do
      video_tactic = build(:video_tactic, video: video, tactic: tactic, display_time: nil)
      expect(video_tactic).not_to be_valid
      expect(video_tactic.errors[:display_time]).to be_present
    end

    it "display_time が負数だと無効" do
      video_tactic = build(:video_tactic, video: video, tactic: tactic, display_time: -0.5)
      expect(video_tactic).not_to be_valid
      expect(video_tactic.errors[:display_time]).to be_present
    end

    it "display_time は数値でなければ無効" do
      video_tactic = build(:video_tactic, video: video, tactic: tactic, display_time: "abc")
      expect(video_tactic).not_to be_valid
      expect(video_tactic.errors[:display_time]).to be_present
    end
  end
end

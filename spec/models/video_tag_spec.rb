require "rails_helper"

RSpec.describe VideoTag, type: :model do
  let(:video) { create(:video) }
  let(:tag)   { create(:tag) }

  describe "associations" do
    it "video に属している" do
      video_tag = build(:video_tag, video: video)
      expect(video_tag.video).to eq(video)
    end

    it "tag に属している" do
      video_tag = build(:video_tag, tag: tag)
      expect(video_tag.tag).to eq(tag)
    end
  end

  describe "validations" do
    it "video と tag があれば有効" do
      video_tag = build(:video_tag, video: video, tag: tag)
      expect(video_tag).to be_valid
    end

    it "video がなければ無効" do
      video_tag = build(:video_tag, video: nil, tag: tag)
      expect(video_tag).not_to be_valid
      expect(video_tag.errors[:video]).to be_present
    end

    it "tag がなければ無効" do
      video_tag = build(:video_tag, video: video, tag: nil)
      expect(video_tag).not_to be_valid
      expect(video_tag.errors[:tag]).to be_present
    end

    it "video_id と tag_id の組み合わせが重複すると無効" do
      create(:video_tag, video: video, tag: tag) # 1件目
      duplicate = build(:video_tag, video: video, tag: tag) # 同じ組み合わせ

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:video_id]).to be_present
    end

    it "異なる video なら同じ tag を使っても有効" do
      other_video = create(:video)
      create(:video_tag, video: video, tag: tag)

      new_record = build(:video_tag, video: other_video, tag: tag)
      expect(new_record).to be_valid
    end

    it "異なる tag なら同じ video に付けても有効" do
      other_tag = create(:tag)
      create(:video_tag, video: video, tag: tag)

      new_record = build(:video_tag, video: video, tag: other_tag)
      expect(new_record).to be_valid
    end
  end
end

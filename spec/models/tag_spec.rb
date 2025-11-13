require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe "validations" do
    it "name があれば有効" do
      tag = build(:tag, name: "オフェンス")
      expect(tag).to be_valid
    end

    it "name が空だと無効" do
      tag = build(:tag, name: "")
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to be_present
    end

    it "同じ名前が重複すると無効" do
      create(:tag, name: "オフェンス")
      tag = build(:tag, name: "オフェンス")
      expect(tag).not_to be_valid
    end

    it "大文字小文字が違っても重複は無効（case-insensitive）" do
      create(:tag, name: "Defense")
      tag = build(:tag, name: "defense")
      expect(tag).not_to be_valid
    end

    it "name の前後の空白は保存前に自動的に削除される" do
      tag = create(:tag, name: "  オフェンス  ")
      expect(tag.reload.name).to eq("オフェンス")
    end

    context "全角入力禁止のバリデーション" do
      it "半角英数字のみなら有効" do
        tag = build(:tag, name: "Offense123")
        expect(tag).to be_valid
      end

      it "全角英字が含まれていると無効" do
        tag = build(:tag, name: "Ｏｆｆｅｎｓｅ") # 全角Ｏ
        expect(tag).not_to be_valid
        expect(tag.errors[:name]).to include("に全角英数字は使用できません（半角で入力してください）")
      end

      it "全角数字が含まれていると無効" do
        tag = build(:tag, name: "Tag１２３") # 全角１２３
        expect(tag).not_to be_valid
        expect(tag.errors[:name]).to include("に全角英数字は使用できません（半角で入力してください）")
      end

      it "全角スペースが含まれていると無効" do
        tag = build(:tag, name: "Tag　Tag") # 間に全角スペース
        expect(tag).not_to be_valid
        expect(tag.errors[:name]).to include("に全角英数字は使用できません（半角で入力してください）")
      end
    end
  end

  describe "associations" do
    it "video_tags を複数持てる" do
      tag = create(:tag)
      create(:video_tag, tag: tag)
      create(:video_tag, tag: tag)
      expect(tag.video_tags.count).to eq(2)
    end

    it "tag を削除すると関連する video_tags も削除される" do
      tag = create(:tag)
      create(:video_tag, tag: tag)

      expect { tag.destroy }.to change { VideoTag.count }.by(-1)
    end

    it "video_tags を通して videos にアクセスできる" do
      tag = create(:tag)
      video = create(:video)
      create(:video_tag, tag: tag, video: video)

      expect(tag.videos).to include(video)
    end
  end
end

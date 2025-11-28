require "rails_helper"

RSpec.describe Rule, type: :model do
  describe "validations" do
    it "title があれば有効" do
      rule = build(:rule, title: "ダブルドリブル")
      expect(rule).to be_valid
    end

    it "title が空だと無効" do
      rule = build(:rule, title: "")
      expect(rule).not_to be_valid
      expect(rule.errors[:title]).to be_present
    end

    it "title が100文字以内なら有効" do
      rule = build(:rule, title: "a" * 100)
      expect(rule).to be_valid
    end

    it "title が101文字以上だと無効" do
      rule = build(:rule, title: "a" * 101)
      expect(rule).not_to be_valid
      expect(rule.errors[:title]).to be_present
    end

    it "slug があれば有効" do
      rule = build(:rule, slug: "double-dribble")
      expect(rule).to be_valid
    end

    it "slug が空だと無効" do
      rule = build(:rule, slug: "")
      expect(rule).not_to be_valid
      expect(rule.errors[:slug]).to be_present
    end

    it "slug が重複すると無効" do
      create(:rule, slug: "traveling")
      duplicate = build(:rule, slug: "traveling")

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:slug]).to be_present
    end

    it "body が1000文字以内なら有効" do
      rule = build(:rule, body: "a" * 1000)
      expect(rule).to be_valid
    end

    it "body が1001文字以上なら無効" do
      rule = build(:rule, body: "a" * 1001)
      expect(rule).not_to be_valid
      expect(rule.errors[:body]).to be_present
    end

    it "body が空でも有効" do
      rule = build(:rule, body: nil)
      expect(rule).to be_valid
    end
  end
end

require 'rails_helper'

RSpec.describe SuccessCondition, type: :model do
  describe "バリデーション" do
    let(:tactic) { create(:tactic) }

    it "body が100文字以内なら有効" do
      condition = build(:success_condition, tactic: tactic, body: "あ" * 100)
      expect(condition).to be_valid
    end

    it "body が101文字以上だと無効" do
      condition = build(:success_condition, tactic: tactic, body: "あ" * 101)
      expect(condition).not_to be_valid
      expect(condition.errors[:body]).to be_present
    end
  end

  describe "関連" do
    it "tactic に属する" do
      association = described_class.reflect_on_association(:tactic)
      expect(association.macro).to eq(:belongs_to)
    end

    it "videos を dependent: :nullify で has_many" do
      association = described_class.reflect_on_association(:videos)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:nullify)
    end
  end
end

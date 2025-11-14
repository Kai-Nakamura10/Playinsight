require 'rails_helper'

RSpec.describe Choice, type: :model do
  let(:question) { create(:question) }

  describe "バリデーション" do
    it "question と body があれば有効" do
      choice = build(:choice, question: question, body: "選択肢", is_correct: true)
      expect(choice).to be_valid
    end

    it "body が空だと無効" do
      choice = build(:choice, question: question, body: "")
      expect(choice).not_to be_valid
      expect(choice.errors[:body]).to be_present
    end

    it "question が無いと無効" do
      choice = build(:choice, question: nil)
      expect(choice).not_to be_valid
      expect(choice.errors[:question]).to be_present
    end

    it "is_correct は true/false 以外は無効" do
      choice = build(:choice, question: question, is_correct: nil)
      expect(choice).not_to be_valid
      expect(choice.errors[:is_correct]).to be_present
    end
  end
end

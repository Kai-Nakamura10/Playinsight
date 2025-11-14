require 'rails_helper'

RSpec.describe Bestselect, type: :model do
  describe "バリデーション" do
    it "question と explanation があれば有効" do
      bestselect = build(:bestselect, question: "Q1", explanation: "解説")
      expect(bestselect).to be_valid
    end

    it "question が空だと無効" do
      bestselect = build(:bestselect, question: "")
      expect(bestselect).not_to be_valid
      expect(bestselect.errors[:question]).to be_present
    end

    it "explanation が空だと無効" do
      bestselect = build(:bestselect, explanation: "")
      expect(bestselect).not_to be_valid
      expect(bestselect.errors[:explanation]).to be_present
    end
  end

  describe "関連" do
    it "answers を複数持てる" do
      bestselect = create(:bestselect)
      create(:answer, bestselect: bestselect)
      create(:answer, bestselect: bestselect)

      expect(bestselect.answers.size).to eq(2)
    end

    it "bestselect を削除すると answers も削除される" do
      bestselect = create(:bestselect)
      create(:answer, bestselect: bestselect)

      expect { bestselect.destroy }.to change(Answer, :count).by(-1)
    end
  end

  describe "ネストした answers_attributes" do
    it "answers_attributes で answer を同時に作成できる" do
      bestselect = Bestselect.create!(
        question: "Q",
        explanation: "説明",
        answers_attributes: [
          { body: "回答1", is_correct: true, position: 1 },
          { body: "回答2", is_correct: false, position: 2 }
        ]
      )

      expect(bestselect.answers.pluck(:body)).to eq([ "回答1", "回答2" ])
    end
  end
end

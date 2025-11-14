require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "バリデーション" do
    it "content と explanation があれば有効" do
      question = build(:question, content: "Q", explanation: "解説")
      expect(question).to be_valid
    end

    it "content が空だと無効" do
      question = build(:question, content: "")
      expect(question).not_to be_valid
      expect(question.errors[:content]).to be_present
    end

    it "explanation が空だと無効" do
      question = build(:question, explanation: "")
      expect(question).not_to be_valid
      expect(question.errors[:explanation]).to be_present
    end
  end

  describe "関連" do
    it "choices を複数持てる" do
      question = create(:question)
      create(:choice, question: question, body: "A")
      create(:choice, question: question, body: "B")

      expect(question.choices.count).to eq(2)
    end

    it "question 削除時に choices も削除される" do
      question = create(:question)
      create(:choice, question: question)

      expect { question.destroy }.to change(Choice, :count).by(-1)
    end
  end

  describe "ネストした choices_attributes" do
    it "choices_attributes で選択肢を作成できる" do
      question = Question.create!(
        content: "Q",
        explanation: "解説",
        choices_attributes: [
          { body: "A", is_correct: true },
          { body: "B", is_correct: false }
        ]
      )

      expect(question.choices.pluck(:body)).to eq([ "A", "B" ])
    end
  end
end

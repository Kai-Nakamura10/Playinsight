require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:bestselect) { create(:bestselect) }

  describe "バリデーション" do
    it "本文とposition、正誤フラグがあれば有効" do
      answer = build(:answer, bestselect: bestselect, body: "最適解", position: 1, is_correct: true)
      expect(answer).to be_valid
    end

    it "body が空だと無効" do
      answer = build(:answer, bestselect: bestselect, body: "")
      expect(answer).not_to be_valid
      expect(answer.errors[:body]).to be_present
    end

    it "position が nil だと無効" do
      answer = create(:answer, bestselect: bestselect)
      answer.position = nil
      expect(answer).not_to be_valid
      expect(answer.errors[:position]).to be_present
    end

    it "position が 0 以下だと無効" do
      answer = build(:answer, bestselect: bestselect, position: 0)
      expect(answer).not_to be_valid
      expect(answer.errors[:position]).to be_present
    end

    it "position が整数でないと無効" do
      answer = build(:answer, bestselect: bestselect, position: 1.5)
      expect(answer).not_to be_valid
      expect(answer.errors[:position]).to be_present
    end

    it "is_correct が nil だと無効" do
      answer = build(:answer, bestselect: bestselect, is_correct: nil)
      expect(answer).not_to be_valid
      expect(answer.errors[:is_correct]).to be_present
    end
  end

  describe "デフォルトスコープ" do
    it "position 昇順で返す" do
      a1 = create(:answer, bestselect: bestselect, position: 3)
      a2 = create(:answer, bestselect: bestselect, position: 1)
      a3 = create(:answer, bestselect: bestselect, position: 2)

      expect(bestselect.answers).to eq([ a2, a3, a1 ])
    end
  end

  describe "コールバック" do
    it "position が空のとき自動採番される" do
      create(:answer, bestselect: bestselect, position: 5)
      answer = build(:answer, bestselect: bestselect, position: nil)

      answer.valid?

      expect(answer.position).to eq(6)
    end
  end
end

require 'rails_helper'

RSpec.describe Faq, type: :model do
  describe "バリデーション" do
    it "body があれば有効" do
      faq = build(:faq, body: "よくある質問？")
      expect(faq).to be_valid
    end

    it "body が空だと無効" do
      faq = build(:faq, body: "")
      expect(faq).not_to be_valid
      expect(faq.errors[:body]).to be_present
    end

    it "body が重複すると無効" do
      create(:faq, body: "同じ質問")
      faq = build(:faq, body: "同じ質問")

      expect(faq).not_to be_valid
      expect(faq.errors[:body]).to be_present
    end
  end

  describe "関連" do
    it "faqs_answers を複数持てる" do
      faq = create(:faq)
      create(:faqs_answer, faq: faq, body: "回答1")
      create(:faqs_answer, faq: faq, body: "回答2")

      expect(faq.faqs_answers.count).to eq(2)
    end

    it "faq 削除時に faqs_answers も削除される" do
      faq = create(:faq)
      create(:faqs_answer, faq: faq)

      expect { faq.destroy }.to change(FaqsAnswer, :count).by(-1)
    end
  end
end

require 'rails_helper'

RSpec.describe FaqsAnswer, type: :model do
  let(:faq) { create(:faq) }

  describe "バリデーション" do
    it "faq と body がそろえば有効" do
      faqs_answer = build(:faqs_answer, faq: faq, body: "回答")
      expect(faqs_answer).to be_valid
    end

    it "faq が無いと無効" do
      faqs_answer = build(:faqs_answer, faq: nil)
      expect(faqs_answer).not_to be_valid
      expect(faqs_answer.errors[:faq]).to be_present
    end

    it "body が空だと無効" do
      faqs_answer = build(:faqs_answer, faq: faq, body: "")
      expect(faqs_answer).not_to be_valid
      expect(faqs_answer.errors[:body]).to be_present
    end
  end
end

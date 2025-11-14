FactoryBot.define do
  factory :faqs_answer do
    association :faq
    body { "回答本文" }
  end
end

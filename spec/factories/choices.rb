FactoryBot.define do
  factory :choice do
    association :question
    body { "選択肢の本文" }
    is_correct { false }
  end
end

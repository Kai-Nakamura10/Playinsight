FactoryBot.define do
  factory :failure_pattern do
    association :tactic
    sequence(:body) { |n| "失敗パターン#{n}" }
  end
end

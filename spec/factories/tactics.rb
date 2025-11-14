FactoryBot.define do
  factory :tactic do
    sequence(:title) { |n| "戦術タイトル#{n}" }
    description { "戦術の説明" }
    trigger { "きっかけ" }
    steps { {} }
    counters { "対応方法" }
    sequence(:slug) { |n| "tactic-#{n}" }
  end
end

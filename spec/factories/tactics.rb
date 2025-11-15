FactoryBot.define do
  factory :tactic do
    sequence(:title) { |n| "戦術タイトル#{n}" }
    description { "戦術の説明" }
    trigger { "きっかけ" }
    steps do
      {
        "success_conditions" => [ "成功条件1" ],
        "common_failures" => [ "失敗例1" ]
      }
    end
    counters { "対応方法" }
    sequence(:slug) { |n| "tactic-#{n}" }
  end
end

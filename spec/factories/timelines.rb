FactoryBot.define do
  factory :timeline do
    association :video
    kind { "質問" }
    title { "セグメント" }
    start_seconds { 0 }
    end_seconds { nil }
    payload { {} }
  end
end

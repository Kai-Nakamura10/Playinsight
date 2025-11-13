FactoryBot.define do
  factory :timeline do
    association :video
    kind { Timeline::KINDS.sample }
    title { "サンプルタイトル" }
    body  { "サンプル本文" }
    start_seconds { 0 }
    end_seconds   { nil }
    payload { {} }
  end
end

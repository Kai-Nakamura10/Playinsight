FactoryBot.define do
  factory :video do
    association :user
    title { "sample" }
    visibility { "public" }
    duration_seconds { nil }
  end
end

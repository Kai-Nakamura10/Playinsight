FactoryBot.define do
  factory :comment do
    association :user
    association :video
    body { "これはコメント本文です" }
  end
end

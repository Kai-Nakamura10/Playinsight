FactoryBot.define do
  factory :answer do
    association :bestselect
    sequence(:body) { |n| "回答#{n}" }
    sequence(:position) { |n| n }
    is_correct { false }
  end
end

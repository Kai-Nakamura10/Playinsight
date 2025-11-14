FactoryBot.define do
  factory :success_condition do
    association :tactic
    sequence(:body) { |n| "成功条件#{n}" }
  end
end

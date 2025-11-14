FactoryBot.define do
  factory :video_tactic do
    association :video
    association :tactic
    display_time { 0 }
  end
end

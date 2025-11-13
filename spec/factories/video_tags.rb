FactoryBot.define do
  factory :video_tag do
    association :tag
    association :video
  end
end

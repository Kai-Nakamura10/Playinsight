FactoryBot.define do
  factory :faq do
    sequence(:body) { |n| "よくある質問#{n}" }
    category { "general" }
    order { 1 }
  end
end

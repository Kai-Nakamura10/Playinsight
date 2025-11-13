FactoryBot.define do
  factory :rule do
    title { "ダブルドリブル" }
    slug  { "double-dribble-#{SecureRandom.hex(4)}" }
    body  { "ドリブルを2回してしまうと反則です。" }
  end
end

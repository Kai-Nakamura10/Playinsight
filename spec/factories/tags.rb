FactoryBot.define do
  factory :tag do
    name { "Tag #{SecureRandom.hex(4)}" }
  end
end

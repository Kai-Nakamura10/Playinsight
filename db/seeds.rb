# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# 1問目
bestselect1 = Bestselect.create!(
  question: "この状況でベストな選択は？",
  explanation: "相手ディフェンスが2人来ているときはフリーの選手ができる。そこにパスを出すことでシュート成功がしやすくなります"
)

bestselect1.answers.create!([
  { body: "フリーになった5番にパス", position: 1, is_correct: true },
  { body: "その場で止まりジャンプシュート", position: 2, is_correct: false },
  { body: "3pointlineまで戻る", position: 3, is_correct: false },
  { body: "相手を抜いてレイアップ", position: 4, is_correct: false }
])

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
#2問目
bestselect2 = Bestselect.create!(
  question: "この状況でベストな選択は？",
  explanation: "シュートスペースがあるなら、そのままレイアップにしましょう。シュートを狙わないとディフェンスの脅威になりません。"
)

bestselect2.answers.create!([
  { body: "味方の3番にパスをだしてコーナースリー", position: 1, is_correct: false },
  { body: "ステップバックシュート", position: 2, is_correct: false },
  { body: "シュートスペースがあり、そのままレイアップ", position: 3, is_correct: true },
  { body: "ロールしてカッティングしてくる5番にパス", position: 4, is_correct: false }
])
#3問目
bestselect3 = Bestselect.create!(
  question: "この状況でベストな選択は？",
  explanation: "身長差を活かした攻撃はシュート成功率を上げる。"
)

bestselect3.answers.create!([
  { body: "①がインサイドにカット", position: 1, is_correct: false },
  { body: "③にバウンドパス", position: 2, is_correct: false },
  { body: "ミスマッチを活かして1on1", position: 3, is_correct: true },
  { body: "シュートフェイクからのゴール下シュート", position: 4, is_correct: false }
])
#4問目
bestselect4 = Bestselect.create!(
  question: "この状況でベストな選択は？",
  explanation: "スピードで勝てるケースでは1on1で抜く"
)

bestselect4.answers.create!([
  { body: "②にパス", position: 1, is_correct: false },
  { body: "ハンドオフをする", position: 2, is_correct: false },
  { body: "3pointを狙う", position: 3, is_correct: false },
  { body: "スピードで相手を抜く", position: 4, is_correct: true }
])
#5問目
bestselect5 = Bestselect.create!(
  question: "この状況でベストな選択は？",
  explanation: "インサイドアウトはアウトサイドが得意な選手がいると得点を狙える。"
)

bestselect5.answers.create!([
  { body: "プルアップをする", position: 1, is_correct: false },
  { body: "ユーロステップをする", position: 2, is_correct: false },
  { body: "③にパス", position: 3, is_correct: true },
  { body: "ロールターンをする", position: 4, is_correct: false }
])

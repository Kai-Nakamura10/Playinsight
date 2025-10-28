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
# 2問目
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
# 3問目
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
# 4問目
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
# 5問目
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

# 2対1の速攻
tactic = Tactic.find_or_initialize_by(slug: "fastbreak-2on1")
tactic.assign_attributes(
title: "2対1の速攻",
trigger: "DFが1人/中央レーン確保",
description: nil, # 任意
steps: {
"success_conditions" => [
"中央レーン優先",
"パスはDFの外側",
"1回だけフェイク"
],
"common_failures" => [
"突っ込みすぎてブロックされる",
"味方と同じレーンを走る"
]
},
counters: "DFがパス読み → 保持者がそのままレイアップ"
)
tactic.save!

# ピック＆ロール
tactic = Tactic.find_or_initialize_by(slug: "pick-and-roll")
tactic.assign_attributes(
title: "ピック＆ロール",
trigger: "1on1で攻め切れないとき/ディフェンスがドロップしているとき",
description: nil, # 任意
steps: {
"success_conditions" => [
"スクリーンにしっかり接触させる",
"弱サイドのコーナーを空けておく",
"パスのリズムを合わせる"
],
"common_failures" => [
"ガードがスクリーンから距離を空けすぎる",
"ディフェンス2人がボール保持者を追ってパス先"
]
},
counters: "ディフェンスがヘッジ（強く出てくる） → ショートロールで空いたスペースを突く"
)
tactic.save!

# ゾーンディフェンス攻略
tactic = Tactic.find_or_initialize_by(slug: "zone-high-post")
tactic.assign_attributes(
title: "ゾーンオフェンス（ハイポスト起点）",
trigger: "相手が2-3ゾーンや3-2ゾーンで守っているとき",
description: nil, # 任意
steps: {
"success_conditions" => [
"ハイポストにボールを確実に入れる",
"コーナーやウィングのシューターが準備",
"ボールを受けた⑤が「パス・ドライブ・ミドル」の3択を持つ"
],
"common_failures" => [
"外周でパスを回すだけで中に入らない",
"ハイポストで受けた選手が判断を迷ってボールロス"
]
},
counters: "ゾーンが収縮 → 外のシューターにキックアウトして3P"
)
tactic.save!

ActiveRecord::Base.transaction do
  FaqsAnswer.delete_all
  Faq.delete_all
  data = {
    "試合の流れ・時間編" => [
      { q: "バスケの試合は何分あるの？", a: "プロの試合（BリーグやNBA）は1クォーター10分〜12分で、4クォーター制です。前半20〜24分・後半20〜24分と考えればOK。" },
      { q: "どうして試合が何度も止まるの？", a: "タイムアウト、選手交代、ファウル後のスローインなどで止まります。展開が速いからこそ「細かく区切る」必要があります。" },
      { q: "延長戦ってどうなるの？", a: "4クォーターで同点なら、5分間の延長戦をして勝敗を決めます。" }
    ],
    "チーム・選手編" => [
      { q: "なんで選手が急にベンチに戻ったの？", a: "交代です。バスケは疲れやすいスポーツなので、短い時間で選手を入れ替えながら戦います。" },
      { q: "ユニフォームの色はどう決まるの？", a: "基本的にホームチームは白（または明色）、アウェイチームは濃い色です。試合ごとに決められています。" },
      { q: "背番号に意味はあるの？", a: "ルール上の縛りはなく、好きな番号を選べることが多いです。選手のこだわりや縁のある数字が多いですね。" }
    ],
    "会場・応援編" => [
      { q: "どうして試合中に音楽や太鼓が鳴ってるの？", a: "観客を盛り上げたり、チームのリズムを作るためです。特に日本のBリーグでは応援スタイルが特徴的です。" },
      { q: "観客が立ち上がって拍手してるのはなぜ？", a: "好プレーや点数が入った時の盛り上がりです。特に3Pシュートやダンクは大歓声になります。" },
      { q: "試合前に選手がダンスみたいに入場するのはなに？", a: "選手紹介の演出です。音楽やライトアップで盛り上げて「これから試合が始まるぞ！」と雰囲気を作ります。" }
    ],
    "その他" => [
      { q: "バスケの得点ってどうしてすぐに変わるの？", a: "他のスポーツに比べてシュートが入る頻度が高く、数秒ごとに得点が動くこともあります。" },
      { q: "ベンチの人たちが立ち上がってワイワイしてるのは？", a: "自チームの選手を励ましたり、盛り上げるためです。チームの一体感を作る大事な要素です。" },
      { q: "試合中にコーチが選手に叫んでるのはなぜ？", a: "バスケは展開が速いため、試合中に戦術やポジションを指示することが多いからです。" }
    ]
  }

  data.each do |category, items|
    items.each_with_index do |item, idx|
      faq = Faq.create!(
        category: category,
        body: item[:q],
        order: idx + 1
      )
      faq.faqs_answers.create!(body: item[:a])
    end
  end
end

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
def seed_bestselect!(question:, explanation:, answers:, image_filename:)
  bestselect = Bestselect.find_or_initialize_by(question: question, explanation: explanation)
  bestselect.image_filename = image_filename
  bestselect.save!

  bestselect.answers.destroy_all
  bestselect.answers.create!(answers)
end

[
  {
    image_filename: "Group_34_1.svg",
    explanation: "相手ディフェンスが2人来ているときはフリーの選手ができる。そこにパスを出すことでシュート成功がしやすくなります",
    answers: [
      { body: "フリーになった5番にパス", position: 1, is_correct: true },
      { body: "その場で止まりジャンプシュート", position: 2, is_correct: false },
      { body: "3pointlineまで戻る", position: 3, is_correct: false },
      { body: "相手を抜いてレイアップ", position: 4, is_correct: false }
    ]
  },
  {
    image_filename: "Group_34_2.svg",
    explanation: "シュートスペースがあるなら、そのままレイアップにしましょう。シュートを狙わないとディフェンスの脅威になりません。",
    answers: [
      { body: "味方の3番にパスをだしてコーナースリー", position: 1, is_correct: false },
      { body: "ステップバックシュート", position: 2, is_correct: false },
      { body: "シュートスペースがあり、そのままレイアップ", position: 3, is_correct: true },
      { body: "ロールしてカッティングしてくる5番にパス", position: 4, is_correct: false }
    ]
  },
  {
    image_filename: "Group_34_3.svg",
    explanation: "身長差を活かした攻撃はシュート成功率を上げる。",
    answers: [
      { body: "①がインサイドにカット", position: 1, is_correct: false },
      { body: "③にバウンドパス", position: 2, is_correct: false },
      { body: "ミスマッチを活かして1on1", position: 3, is_correct: true },
      { body: "シュートフェイクからのゴール下シュート", position: 4, is_correct: false }
    ]
  },
  {
    image_filename: "Group_34_4.svg",
    explanation: "スピードで勝てるケースでは1on1で抜く",
    answers: [
      { body: "②にパス", position: 1, is_correct: false },
      { body: "ハンドオフをする", position: 2, is_correct: false },
      { body: "3pointを狙う", position: 3, is_correct: false },
      { body: "スピードで相手を抜く", position: 4, is_correct: true }
    ]
  },
  {
    image_filename: "Group_34_5.svg",
    explanation: "インサイドアウトはアウトサイドが得意な選手がいると得点を狙える。",
    answers: [
      { body: "プルアップをする", position: 1, is_correct: false },
      { body: "ユーロステップをする", position: 2, is_correct: false },
      { body: "③にパス", position: 3, is_correct: true },
      { body: "ロールターンをする", position: 4, is_correct: false }
    ]
  }
].each do |attrs|
  seed_bestselect!(
    question: "この状況でベストな選択は？",
    explanation: attrs[:explanation],
    answers: attrs[:answers],
    image_filename: attrs[:image_filename]
  )
end

# 2対1の速攻
tactic = Tactic.find_or_initialize_by(slug: "fastbreak-2on1")
tactic.assign_attributes(
title: "2対1の速攻",
trigger: "DFが1人/中央レーン確保",
description: "パスは少なくする",
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
counters: "DFがパス読み → 保持者がそのままレイアップ",
order: 1
)
tactic.save!

# ピック＆ロール
tactic = Tactic.find_or_initialize_by(slug: "pick-and-roll")
tactic.assign_attributes(
title: "ピック＆ロール",
trigger: "1on1で攻め切れないとき/ディフェンスがドロップしているとき",
description: "ディフェンス二人きたら、ゴールにドライブ",
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
counters: "ディフェンスがヘッジ（強く出てくる） → ショートロールで空いたスペースを突く",
order: 2
)
tactic.save!

# ゾーンディフェンス攻略
tactic = Tactic.find_or_initialize_by(slug: "zone-high-post")
tactic.assign_attributes(
title: "ゾーンオフェンス（ハイポスト起点）",
trigger: "相手が2-3ゾーンや3-2ゾーンで守っているとき",
description: "外を狙うと見せかけてペイントエリアに侵入",
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
counters: "ゾーンが収縮 → 外のシューターにキックアウトして3P",
order: 3
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

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "double-dribble")

  rule.title       = "ダブルドリブル"
  rule.body        = <<~TEXT
    ドリブルとは、ボールをつきながら進む動作のことです。
    一度ドリブルをやめて（ボールを持ったまま止まるなどして）、もう一度ドリブルを始めると「ダブルドリブル」という反則になります。
    👉 つまり、「ドリブルを2回してしまう」とダブルドリブルになります。
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "violation")

  rule.title       = "バイオレーション"
  rule.body        = <<~TEXT
    「バイオレーション」は、ボールの扱い方や試合の進行に関する軽い反則のことを指します。
     例えば、ボールがコートの外に出てしまった場合は「アウト・オブ・バウンズ」と呼ばれるバイオレーションになります。
     👉 ボールをコートの外に出してしまうと、相手チームのボールになります。
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "three-point")

  rule.title       = "3ポイント"
  rule.body        = <<~TEXT
    基本
    コートに描かれた3ポイントライン（アーチ状の線）の外側から放ったシュートが入ると3点になります。
    それ以外（ライン内側）からのシュートは2点です。
    条件
    両足が完全に3ポイントラインの外にあることが必要です。
    足が少しでもラインに触れていたら2点になります。
    シュートモーションのときに空中にいても、踏み切り位置が外側ならOKです。
    フリースローとの違い
    フリースローは1点ですが、3ポイントは一度に3点を狙えるため、試合の流れを大きく変えるプレーとしてとても重要です。
    よくある初心者の疑問
    Q1: 3ポイントってどのくらいの距離？
    → プロの試合ではゴールから 6.75m（FIBA）/7.24m（NBA）。思った以上に遠い距離です。
    Q2: ラインを踏んだら？
    → 2点シュートとしてカウントされます。
    Q3: ファウルを受けながら3ポイントを打ったら？
    → 入れば「3点+フリースロー1本（最大4点）」、外れれば「フリースロー3本」が与えられます。
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "free-throw")

  rule.title       = "フリースロー"
  rule.body        = <<~TEXT
    基本ルール
    ファウルを受けた選手が、決められた位置（フリースローライン）から、相手に邪魔されずにシュートを打ちます。
    1本のシュートにつき1点です。
    フリースローラインはゴールから4.225mの位置にあります。
    どんなときに与えられる？
    シュート中にファウルを受けたとき
    チームが1クォーター内で5回目以降のチームファウルをしたとき（=ボーナススロー）
    テクニカルファウル、アンスポーツマンライクファウルなど特殊なファウルのとき
    打ち方のルール
    ボールをもらってから5秒以内にシュートする
    ボールがリングに当たるまではラインを踏んだり越えたりしてはいけない
    味方も相手も、審判がボールを渡した瞬間から制限区域（ペイントエリア）に入ってはいけない
    よくある初心者の疑問
    Q1: フリースローは何本打てるの？
    → 2点シュート中のファウル → 2本
      3点シュート中のファウル → 3本
      もし入ってもファウルを受けていたら「1本」追加で打てます。
    Q2: チームファウルってなに？
    → 1クォーターで5回ファウルをすると、以降は相手に自動的にフリースローが与えられます。
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "unsportsmanlike-foul")

  rule.title       = "アンスポーツマンライクファウル"
  rule.body        = <<~TEXT
    基本
   「スポーツマンらしくないファウル」のこと。
    危険だったり、不必要に強い接触をしたときに取られます。
    具体的なケース
    相手の速攻を後ろから押す・腕を引っ張るなど危険なプレー
    ボールに関係なく、相手を強く止めようとする行為
    ボールを持っていない選手への乱暴な接触
    強く体をぶつけるなど、安全を欠いた動き
    罰則
    相手チームにフリースロー2本+ボール保持権が与えられる
    通常のファウルと違い、必ず得点チャンスが生まれる
    よくある初心者の疑問
    Q1: 普通のファウルと何が違うの？
    → 普通のファウルは「ボールを守るためのプレー」で起こる。
      アンスポは「危険・不必要な接触」と判断されたときに取られます。
    Q2: 退場になるの？
    → 1試合で2回アンスポを取られた選手は退場になります。
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "illegal-foul")

  rule.title       = "イリーガルファウル"
  rule.body        = <<~TEXT
    基本
    「イリーガル＝不正」という意味で、試合中の不正な接触や行為をまとめて指します。
    つまり、通常のファウル（反則行為）をわかりやすく説明する言い方です。
    主な例
    イリーガル・スクリーン：スクリーン時に体を動かしたり相手を押す反則
    イリーガル・ハンドチェック：手で相手を押したり進行を妨害する反則
    イリーガル・ユース・オブ・ハンズ：ボールを持っていない相手の腕をつかむ・叩くなどの行為
    👉 まとめると「相手のプレーを不正に妨害する行為全般」がイリーガルファウルです。
    罰則
    状況によって、相手チームにスローインまたはフリースローが与えられます。
    通常のパーソナルファウルと同じ扱いで、累積するとチームファウルになり、相手にフリースローが与えられます。
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "technical-foul")

  rule.title       = "テクニカルファウル"
  rule.body        = <<~TEXT
    基本
    スポーツマンシップに反する行為や、試合の進行を妨げる不正な行為をした場合に科されるファウルです。
    選手だけでなく、コーチやベンチメンバーにも適用されます。
    主なケース
    審判への不満・抗議
    選手やコーチが審判に文句を言ったり、判定に対して過剰に反応する場合。
    例：審判に向かって叫ぶ、腕を広げて抗議する、ベンチから声を荒げるなど。
    暴言や不適切な態度
    侮辱的な言葉を使ったり、指を差して挑発する・大声で怒鳴るなどの行為。
    例：審判の判定に対して怒鳴ったり、挑発的なジェスチャーをすること。
    プレー外での不正行動
    プレーと関係のない場面で、ルールを無視したり試合を妨げる行為。
    例：故意に試合を遅らせる、備品を壊す、コートに物を投げる など。
    罰則
    状況によって、相手チームにスローインまたはフリースローが与えられます。
    通常のパーソナルファウルと同じ扱いで、累積するとチームファウルになり、相手にフリースローが与えられます。
    よくある例
    選手が審判の判定に何度も文句を言い続けた場合。
    ベンチのコーチが大声で反論し、試合を止めた場合。
    まとめ
    テクニカルファウルは、スポーツマンらしさを欠いた言動や不正行為に対して与えられる反則です。
    試合中は、冷静な態度とリスペクトが求められます。
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "two-point-shot")

  rule.title       = "2ポイントシュート"
  rule.body        = <<~TEXT
    基本
    3ポイントラインの内側から放ったシュートは2点になります。
    ゴール下のレイアップやダンクも、すべて2ポイントです。
    条件
    両足が3ポイントラインの内側、またはラインに触れている場合は2点。
    3ポイントを狙っても、足がラインにかかっていれば2点扱いになります。
    フリースローとの違い
    フリースローは1点ずつですが、2ポイントシュートは流れの中で一度に2点入ります。
    よくある初心者の疑問
    Q: ダンクやゴール下のシュートも2点？
    → はい、すべて2点です。シュートの種類は関係ありません。
    Q: 3ポイントラインを踏んでいたら？
    → ラインに触れている時点で2点になります。
    Q: ファウルを受けながら決めたら？
    → 入れば「2点+フリースロー1本」、外れた場合は「フリースロー2本」が与えられます。
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "blocking-foul")

  rule.title       = "ブロッキングファウル"
  rule.body        = <<~TEXT
    基本
    ディフェンスの選手が、オフェンス選手の進行方向を不正に妨げた場合に取られるファウルです。
    正しい位置取りをしていない、または動いている状態で接触したときに適用されます。
    条件
    ディフェンスが進行方向の正面にいない
    動きながら接触してしまった場合
    静止していない状態で進路を塞いだ場合
    正しいディフェンスの条件
    オフェンスより先に位置を取ること
    完全に静止していること
    例
    ドリブルで突っ込んできたオフェンスに対して、動きながら横からぶつかるとブロッキングファウルになります。
    まとめ
    ブロッキングファウルは、ディフェンスの位置取りが不正確で進路を妨げたときに取られる反則です。
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "traveling")

  rule.title       = "トラベリング"
  rule.body        = <<~TEXT
    基本
    ボールを持ってから3歩以上動く、または軸足を動かすと反則になります。
    ボールを持ったまま不正に移動することを「トラベリング」と呼びます。
    1. レイアップ時の2歩ルール
    レイアップでは、ボールを持ってから2歩まではOK。
    ただし、3歩目を踏むとトラベリングになります。
    （ボールを持つタイミングも重要です）
    2. 軸足とピボットのルール
    ボールを受けて止まったとき、最初に着地した足が軸足になります。
    軸足を軸にして回転（ピボット）はOKですが、
    その軸足を動かしたり浮かせるとトラベリングです。
    例
    ボールを持ってストップしたあと、軸足をずらしたり、踏み替えたらトラベリングになります。
    まとめ
    レイアップでは2歩までOK、3歩目は反則
    軸足を動かしたらトラベリング
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "backcourt-violation")

  rule.title       = "バックコートバイオレーション"
  rule.body        = <<~TEXT
    自分のチームがボールを前のコート（相手チームのゴール側）に運んだあとで、再び自分たちの後ろのコート（自分のゴール側）に戻してしまうと「バックコート・バイオレーション」となります。
     👉 一度ハーフラインを越えたら、もう後ろには戻れません。
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "eight-second-violation")

  rule.title       = "8秒バイオレーション"
  rule.body        = <<~TEXT
    チームが自分のコートでボールを持ったとき、8秒以内にハーフライン（コートの中央線）を越えなければなりません。
    もし8秒を過ぎても自陣にいた場合は「8秒バイオレーション」となり、相手ボールになります。
    👉 攻撃に移るスピードを求めるルールです。
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "twenty-four-second-violation")

  rule.title       = "24秒バイオレーション"
  rule.body        = <<~TEXT
    攻撃を始めてから、24秒以内にシュートを打たなければいけません。
    シュートがリングに当たらず時間が過ぎると「24秒バイオレーション」となり、相手ボールになります。
    👉 攻撃のテンポを保つためのルールです。
  TEXT

  rule.save!
end

Rule.transaction do
  rule = Rule.find_or_initialize_by(slug: "kicked-ball-violation")

  rule.title       = "キックボールバイオレーション"
  rule.body        = <<~TEXT
    守備中でも攻撃中でも、足やひざなどでボールを意図的に蹴ると反則になります。
    👉 バスケットボールは手で扱うスポーツなので、足を使うのはNGです。
  TEXT

  rule.save!
end

ActiveRecord::Base.transaction do
  QuestionAttempt.delete_all
  def seed_question!(content:, explanation:, choices:, correct_index:)
    q = Question.find_or_initialize_by(content: content)
    q.explanation = explanation
    q.save!

    q.choices.destroy_all
    choices.each_with_index do |text, i|
      q.choices.create!(
        body: text,
        is_correct: (i == correct_index)
      )
    end
  end

  seed_question!(
    content: "Q1. ピック＆ロールとは？",
    choices: [
      "ボールを持つ選手が1人で攻める",
      "味方が体で壁（スクリーン）を作り、ボールを持つ選手がその横を通る",
      "相手を3人で囲んでボールを奪う",
      "シュートを打たずに時間をかける"
    ],
    correct_index: 1,
    explanation: "味方がディフェンスの前に立って壁を作り、ボール保持者がその横を通って攻める戦術（スクリーン＆ロール）。"
  )

  seed_question!(
    content: "Q2. アイソレーション（1対1）の目的は？",
    choices: [
      "味方全員で相手を囲む",
      "ボールを持っていない選手が走り回る",
      "ボールを持つ選手がスペースを作って1対1を仕掛ける",
      "ディフェンス全員でゴール下を守る"
    ],
    correct_index: 2,
    explanation: "チームメイトがスペースを空け、ボール保持者が1対1を仕掛けやすくするための戦術。"
  )

  seed_question!(
    content: "Q3. ゾーンディフェンスの特徴は？",
    choices: [
      "相手選手をそれぞれ1人ずつ守る",
      "ボールを持つ人だけを見る",
      "それぞれの「エリア」を守る",
      "相手にわざと攻めさせる"
    ],
    correct_index: 2,
    explanation: "“人”ではなく“エリア”を分担して守る。外からのシュートに弱点が出やすい。"
  )

  seed_question!(
    content: "Q4. ファストブレイク（速攻）の狙いは？",
    choices: [
      "ディフェンスが整う前に一気に攻めて得点する",
      "パスを何度も回して時間を使う",
      "相手のファウルをわざと誘う",
      "ボールをキープして休む"
    ],
    correct_index: 0,
    explanation: "相手守備が整う前に素早く攻めて高確率で得点を狙う。"
  )

  seed_question!(
    content: "Q5. プレスディフェンスの特徴は？",
    choices: [
      "ゴール下だけを守る守備",
      "コート全体で相手に激しくプレッシャーをかける守備",
      "相手にわざとシュートを打たせる守備",
      "味方全員でベンチに座る"
    ],
    correct_index: 1,
    explanation: "コート全体で積極的にボールやパスコースへ圧力をかけ、ミスを誘う守備戦術。"
  )
end

puts "Seeded basketball quiz (5 questions)."

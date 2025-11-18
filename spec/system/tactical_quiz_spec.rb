require 'rails_helper'

RSpec.describe "Tactical quiz", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:question) do
    create(
      :question,
      content: "2-3ゾーンを攻略する最適な初動は？",
      explanation: "最終的なテキストはAIが補完します。"
    )
  end

  let!(:correct_choice) do
    create(
      :choice,
      question: question,
      body: "ハイポストにフラッシュしてギャップを突く",
      is_correct: true
    )
  end

  let!(:drive_choice) do
    create(
      :choice,
      question: question,
      body: "トップから個人ドライブで崩す",
      is_correct: false
    )
  end

  let!(:reset_choice) do
    create(
      :choice,
      question: question,
      body: "一度バックコートに戻して仕切り直す",
      is_correct: false
    )
  end

  let(:ai_payload) do
    {
      summary: "ゾーンのハイポストを素早く突いてディフェンスを収縮させるのが要点です。",
      selected_reason: "ギャップでボールを受けることで守備が中央に集まり、ウィングへの合わせが生まれます。",
      per_choice: [
        { index: 1, correct: true, reason: "守備の中心部にズレを作れる" },
        { index: 2, correct: false, reason: "個人突破はカバーされやすい" },
        { index: 3, correct: false, reason: "リセットで攻撃が停滞する" }
      ],
      tip: "ハイポストでターン＆フェイスし、即座にアウトサイドへ展開しましょう。"
    }
  end

  def answer_question(with_choice)
    visit question_path(question)
    choose with_choice.body
    click_button "回答する"
  end

  it "shows the AI explanation with all sections when the correct answer is chosen" do
    expect(AiAnswerExplainer).to receive(:call).and_return([ ai_payload, 432,"gpt-test" ])

    answer_question(correct_choice)

    expect(page).to have_content("あなたの回答：#{correct_choice.body}")
    expect(page).to have_content("正解！")

    expect(page).to have_content("🤖 AIの解説")
    expect(page).to have_content("📋 要点: #{ai_payload[:summary]}")
    expect(page).to have_content("🎯 あなたの解答について: #{ai_payload[:selected_reason]}")
    expect(page).to have_content("📝 各選択肢の解説")

    ai_payload[:per_choice].each do |per_choice|
      referenced_choice = [ correct_choice, drive_choice, reset_choice ][per_choice[:index] - 1]
      expect(page).to have_content(referenced_choice.body)
      expect(page).to have_content(per_choice[:reason])
      expect(page).to have_content(per_choice[:correct] ? "✅ 正解" : "❌ 不正解")
    end

    expect(page).to have_content("💡 実戦ワンポイント: #{ai_payload[:tip]}")
  end

  it "marks the answer incorrect but still renders the AI feedback" do
    expect(AiAnswerExplainer).to receive(:call).and_return([ ai_payload, 512,"gpt-test" ])

    answer_question(drive_choice)

    expect(page).to have_content("あなたの回答：#{drive_choice.body}")
    expect(page).to have_content("不正解…")
    expect(page).to have_content("🤖 AIの解説")
    expect(page).to have_content(ai_payload[:summary])
    expect(page).to have_content(ai_payload[:selected_reason])
    expect(page).to have_content(ai_payload[:tip])
  end
end

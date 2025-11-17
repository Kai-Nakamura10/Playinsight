require 'rails_helper'

RSpec.describe "Situational judgment quiz", type: :system do
  let(:password) { "secure-pass123" }
  let!(:user) do
    create(:user, password: password, password_confirmation: password)
  end

  let!(:first_bestselect) do
    create(
      :bestselect,
      question: "トランジションで最適な判断は？",
      explanation: "スペーシングを維持しながら速攻を決めるのがポイントです。"
    )
  end

  let!(:correct_answer) do
    create(
      :answer,
      bestselect: first_bestselect,
      body: "ウィングに走ってディフェンスを外へ広げる",
      position: 1,
      is_correct: true
    )
  end

  let!(:wrong_answer) do
    create(
      :answer,
      bestselect: first_bestselect,
      body: "ハーフライン付近でドリブルを止める",
      position: 2,
      is_correct: false
    )
  end

  let!(:next_bestselect) do
    create(
      :bestselect,
      question: "ハーフコートでの最適解は？",
      explanation: "ボールサイドとウィークサイドのテンポ差を利用します。"
    )
  end

  let!(:next_quiz_answer) do
    create(
      :answer,
      bestselect: next_bestselect,
      body: "ハイポストにギャップエントリーする",
      position: 1,
      is_correct: true
    )
  end

  def sign_in!
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: password
    click_button "ログイン"
  end

  describe "answering the quiz", js: true do
    it "shows questions, accepts answers, and toggles explanations" do
      sign_in!
      visit bestselect_path(first_bestselect)

      expect(page).to have_content(first_bestselect.question)
      expect(page).to have_content(correct_answer.body)
      expect(page).to have_content(wrong_answer.body)

      find("li", text: correct_answer.body).click
      expect(page).to have_css("[data-bestselect-target='result']", text: "正解")
      expect(page).to have_css("[data-bestselect-target='explanation']:not(.hidden)", text: first_bestselect.explanation)

      click_button "もう一度"
      expect(page).to have_css("[data-bestselect-target='result']", text: /\A\s*\z/)
      expect(page).to have_css("[data-bestselect-target='explanation'].hidden")

      find("li", text: wrong_answer.body).click
      expect(page).to have_css("[data-bestselect-target='result']", text: "不正解")
      expect(page).to have_css("[data-bestselect-target='explanation'].hidden")
    end

    it "navigates to the next problem with the next button" do
      sign_in!
      visit bestselect_path(first_bestselect)

      click_link "次の問題へ"

      expect(page).to have_current_path(bestselect_path(next_bestselect))
      expect(page).to have_content(next_bestselect.question)
      expect(page).to have_css("[data-bestselect-target='explanation'].hidden")
    end
  end
end

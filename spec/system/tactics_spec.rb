require 'rails_helper'

RSpec.describe "Tactics management", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:password) { "secure-pass123" }
  let!(:user) do
    create(:user, password: password, password_confirmation: password)
  end

  def sign_in!
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: password
    click_button "ログイン"
  end

  describe "show page" do
    let!(:tactic) do
      create(
        :tactic,
        title: "サークルモーション",
        trigger: "ウィングエントリー",
        description: "トリプルハンドオフで崩す。\nギャップを作る。",
        steps: {
          "success_conditions" => [ "ハイポストでキャッチする", "ウィークサイドの連動" ],
          "common_failures" => [ "スペーシングが詰まる" ]
        },
        counters: "ゾーンチェンジでずらす",
        slug: "circle-motion"
      )
    end

    it "shows the stored tactic details with the correct background image" do
      sign_in!
      visit tactic_path(tactic)

      expect(page).to have_content("サークルモーション")
      expect(page).to have_content("トリガー：ウィングエントリー")
      expect(page).to have_content("トリプルハンドオフで崩す。")
      expect(page).to have_content("ハイポストでキャッチする")
      expect(page).to have_content("ウィークサイドの連動")
      expect(page).to have_content("スペーシングが詰まる")
      expect(page).to have_content("ゾーンチェンジでずらす")
      expect(page).to have_css(".relative[style*='Group_1_#{tactic.id}.svg']")
    end
  end

  describe "navigation buttons and background image swapping" do
    let!(:first_tactic)  { create(:tactic, title: "戦術A", slug: "tactic-a") }
    let!(:middle_tactic) { create(:tactic, title: "戦術B", slug: "tactic-b") }
    let!(:last_tactic)   { create(:tactic, title: "戦術C", slug: "tactic-c") }

    it "moves to next and previous tactics and updates the diagram" do
      sign_in!
      visit tactic_path(middle_tactic)

      expect(page).to have_css(".relative[style*='Group_1_#{middle_tactic.id}.svg']")

      click_link "次の戦術 →"
      expect(page).to have_current_path(tactic_path(last_tactic))
      expect(page).to have_css(".relative[style*='Group_1_#{last_tactic.id}.svg']")

      click_link "← 前の戦術"
      expect(page).to have_current_path(tactic_path(middle_tactic))
      expect(page).to have_css(".relative[style*='Group_1_#{middle_tactic.id}.svg']")
    end
  end

  describe "creating tactics" do
    let(:success_lines) { "リムへアタック\nコーナーシューターを待つ" }
    let(:failure_lines) { "ボールが止まる" }

    it "allows a user to create a tactic with valid input" do
      sign_in!
      visit new_tactic_path

      fill_in "タイトル", with: "プッシュブレイク"
      fill_in "スラッグ", with: "push-break"
      fill_in "トリガー", with: "リバウンド確保"
      fill_in "説明", with: "リバウンド後に5秒以内で仕掛ける。"
      fill_in "成功条件（1行=1項目）", with: success_lines
      fill_in "よくある失敗（1行=1項目）", with: failure_lines
      fill_in "カウンター（文字列でOK）", with: "ゾーンプレスにはドラッグスクリーン"

      expect do
        find('input[type="submit"]').click
      end.to change(Tactic, :count).by(1)

      created = Tactic.find_by(slug: "push-break")
      expect(page).to have_current_path(edit_tactic_path(created))
      expect(find_field("成功条件（1行=1項目）").value).to eq(success_lines)
      expect(find_field("よくある失敗（1行=1項目）").value).to eq(failure_lines)
      expect(find_field("カウンター（文字列でOK）").value).to eq("ゾーンプレスにはドラッグスクリーン")
    end

    it "shows validation errors when required fields are blank" do
      sign_in!
      visit new_tactic_path

      expect do
        find('input[type="submit"]').click
      end.not_to change(Tactic, :count)

      expect(page).to have_current_path(tactics_path)
      expect(page).to have_css(".field_with_errors")
    end
  end
end

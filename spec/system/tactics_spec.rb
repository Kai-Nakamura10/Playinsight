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

    # it "shows the stored tactic details with the correct background image" do
    #   sign_in!
    #   visit tactic_path(tactic)

    #   expect(page).to have_content("サークルモーション")
    #   expect(page).to have_content("トリガー：ウィングエントリー")
    #   expect(page).to have_content("トリプルハンドオフで崩す。")
    #   expect(page).to have_content("ハイポストでキャッチする")
    #   expect(page).to have_content("ウィークサイドの連動")
    #   expect(page).to have_content("スペーシングが詰まる")
    #   expect(page).to have_content("ゾーンチェンジでずらす")
    #   expect(page).to have_css(".relative[style*='Group_1_#{1}.svg']")
    # end
  end

  # describe "navigation buttons and background image swapping" do
  #   let!(:first_tactic)  { create(:tactic, title: "戦術A", slug: "tactic-a") }
  #   let!(:middle_tactic) { create(:tactic, title: "戦術B", slug: "tactic-b") }
  #   let!(:last_tactic)   { create(:tactic, title: "戦術C", slug: "tactic-c") }

  #   it "moves to next and previous tactics and updates the diagram" do
  #     sign_in!
  #     visit tactic_path(middle_tactic)

  #     expect(page).to have_css(".relative[style*='Group_1_#{1}.svg']")

  #     click_link "次の戦術 →"
  #     expect(page).to have_current_path(tactic_path(last_tactic))
  #     expect(page).to have_css(".relative[style*='Group_1_#{1}.svg']")

  #     click_link "← 前の戦術"
  #     expect(page).to have_current_path(tactic_path(middle_tactic))
  #     expect(page).to have_css(".relative[style*='Group_1_#{2}.svg']")
  #   end
  # end

  describe "creating tactics" do
    let(:success_lines) { "リムへアタック\nコーナーシューターを待つ" }
    let(:failure_lines) { "ボールが止まる" }

    it "allows a user to create a tactic with valid input" do
      sign_in!
      visit new_tactic_path

      fill_in "タイトル", with: "プッシュブレイク"
      fill_in "スラッグ", with: "push-break"
      fill_in "トリガー", with: "リバウンド確保"
      click_button "次へ"
      fill_in "説明", with: "リバウンド後に5秒以内で仕掛ける。"
      click_button "次へ"
      fill_in "成功条件（1行=1項目）", with: success_lines
      fill_in "よくある失敗（1行=1項目）", with: failure_lines
      click_button "次へ"
      fill_in "カウンター（文字列でOK）", with: "ゾーンプレスにはドラッグスクリーン"

      expect do
        find('input[type="submit"]').click
      end.to change(Tactic, :count).by(1)

      created = Tactic.find_by(slug: "push-break")
      expect(page).to have_current_path(edit_tactic_path(created))
      click_button "次へ"
      click_button "次へ"
      expect(find_field("成功条件（1行=1項目）").value).to eq(success_lines)
      expect(find_field("よくある失敗（1行=1項目）").value).to eq(failure_lines)
      click_button "次へ"
      expect(find_field("カウンター（文字列でOK）").value).to eq("ゾーンプレスにはドラッグスクリーン")
    end

    it "shows validation errors when required fields are blank" do
      sign_in!
      visit new_tactic_path

      click_button "次へ"
      click_button "次へ"
      click_button "次へ"
      expect do
        find('input[type="submit"]').click
      end.not_to change(Tactic, :count)

      expect(page).to have_current_path(tactics_path)
      expect(page).to have_css(".field_with_errors")
    end
  end

  describe "match analysis workflows", js: true do
    let!(:existing_tag) { create(:tag, name: "トランジション") }
    let!(:available_tactic) { create(:tactic, title: "ゾーンアタックセット") }

    it "allows uploading a video and enriching it with tags, timelines, comments, and tactics" do
      video_title = "試合分析テスト動画"
      timeline_note = "2-3ゾーンをアタック"
      comment_body = "12秒でギャップが空いたのでフレアカットを優先"
      display_time = "6.5"
      uploaded_file = Tempfile.new([ "match-analysis", ".mp4" ])
      uploaded_file.binmode
      uploaded_file.write("FAKEVIDEO")
      uploaded_file.rewind

      sign_in!
      visit new_video_path

      fill_in "video_title", with: video_title
      fill_in "video_description", with: "セカンダリーブレイクの意思統一を振り返る"
      select "公開", from: "video_visibility"
      attach_file "動画ファイル", uploaded_file.path

      expect do
        click_button "アップロード"
      end.to change(Video, :count).by(1)

      video = Video.find_by!(title: video_title)
      expect(page).to have_current_path(video_path(video))
      expect(page).to have_content(video_title)
      expect(page).to have_content("公開設定: 公開")

      within(all("form[action='#{video_video_tags_path(video)}']").first) do
        select existing_tag.name, from: "tag_id"
        click_button "追加"
      end

      within("#video-tags") do
        expect(page).to have_content("##{existing_tag.name}")
      end

      new_tag_name = "フィジカル"
      within(all("form[action='#{video_video_tags_path(video)}']").last) do
        fill_in "name", with: new_tag_name
        click_button "作成して追加"
      end

      within("#video-tags") do
        expect(page).to have_content("##{new_tag_name}")
      end

      within("form[action='#{video_timelines_path(video)}']") do
        fill_in "timeline_start_seconds", with: "12.3"
        select "戦術", from: "timeline_kind"
        fill_in "timeline_body", with: timeline_note
        click_button "タイムラインを追加"
      end

      expect(page).to have_css("#timelines_list", text: "開始時間: 12.3 秒")
      expect(page).to have_css("#timelines_list", text: timeline_note)

      within("#new_comment_form") do
        fill_in "コメント", with: comment_body
        click_button "コメントを投稿"
      end

      within("#comments_list") do
        expect(page).to have_content(comment_body)
      end

      within("form[action='#{video_tactics_path()}']") do
        select available_tactic.title, from: "video_tactic_tactic_id"
        fill_in "vt_display_time_new", with: display_time
        click_button "追加"
      end

      expect(page).to have_current_path(video_path(video))

      within(:xpath, "//h3[contains(.,'登録済みの戦術')]/following-sibling::table[1]") do
        expect(page).to have_content(available_tactic.title)
        # expect(page).to have_content(display_time)
      end
    ensure
      uploaded_file.close
      uploaded_file.unlink
    end
  end
end

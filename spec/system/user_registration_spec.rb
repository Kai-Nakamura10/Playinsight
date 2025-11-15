require 'rails_helper'

RSpec.describe "User registration", type: :system do
  before do
    driven_by(:rack_test)
  end

  def visit_registration_page
    visit new_user_registration_path
  end

  def submit_registration(nickname:, email:, password:, password_confirmation: password)
    fill_in "ニックネーム", with: nickname if nickname
    fill_in "メールアドレス", with: email if email
    fill_in "パスワード", with: password if password
    fill_in "パスワード (確認用)", with: password_confirmation if password_confirmation
    click_button "登録"
  end

  it "registers successfully when all fields are provided" do
    visit_registration_page

    expect do
      submit_registration(
        nickname: "プレイヤー1",
        email: "player1@example.com",
        password: "password123"
      )
    end.to change(User, :count).by(1)

    expect(page).to have_content("サインアウト")
  end

  it "fails to register when the required fields are blank" do
    visit_registration_page

    expect do
      submit_registration(
        nickname: nil,
        email: nil,
        password: nil,
        password_confirmation: nil
      )
    end.not_to change(User, :count)

    expect(page).to have_css("#error_explanation")
    expect(page).to have_content("ニックネームを入力してください")
    expect(page).to have_content("メールアドレスを入力してください")
    expect(page).to have_content("パスワードを入力してください")
  end

  it "fails to register when using an already registered email address" do
    create(:user, email: "duplicate@example.com")

    visit_registration_page
    submit_registration(
      nickname: "重複ユーザー",
      email: "duplicate@example.com",
      password: "password123"
    )

    expect(page).to have_css("#error_explanation")
    expect(page).to have_content("メールアドレスはすでに存在します")
  end
end

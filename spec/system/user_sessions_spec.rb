require 'rails_helper'

RSpec.describe "User sessions", type: :system do
  before do
    driven_by(:rack_test)
    ActionMailer::Base.deliveries.clear
  end

  let(:password) { "password123" }
  let!(:user) do
    create(
      :user,
      email: "session-user@example.com",
      password: password,
      password_confirmation: password
    )
  end

  def login(email:, password:, remember_me: false)
    visit new_user_session_path
    fill_in "メールアドレス", with: email if email
    fill_in "パスワード", with: password if password
    check "ログイン状態を保存する" if remember_me
    click_button "ログイン"
  end

  def expect_password_reset_flash
    expect(page).to satisfy do |p|
      p.has_content?("You will receive an email with instructions on how to reset your password in a few minutes.") ||
        p.has_content?("If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.")
    end
  end

  def remember_cookie_value
    page.driver.browser.rack_mock_session.cookie_jar["remember_user_token"]
  end

  def set_remember_cookie(value)
    page.driver.browser.rack_mock_session.cookie_jar["remember_user_token"] = value
  end

  def fetch_reset_token(for_user)
    token = for_user.send_reset_password_instructions
    ActionMailer::Base.deliveries.clear
    token
  end

  it "logs in successfully with valid credentials" do
    login(email: user.email, password: password)

    expect(page).to have_link("サインアウト")
    expect(page).not_to have_link("サインイン", exact_text: "サインイン")
  end

  it "fails to log in when the form is submitted blank" do
    visit new_user_session_path
    click_button "ログイン"

    expect(page).to have_current_path(new_user_session_path)
    expect(page).not_to have_link("サインアウト")
    expect(page).to have_content("Invalid Email or password.")
  end

  it "fails to log in when the password is incorrect" do
    login(email: user.email, password: "wrong-password")

    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content("Invalid Email or password.")
  end

  it "logs out successfully after logging in" do
    login(email: user.email, password: password)

    page.driver.submit :delete, destroy_user_session_path, {}

    expect(page).to have_link("サインイン")
    expect(page).not_to have_link("サインアウト")
  end

  it "keeps the user signed in when remember me is enabled" do
    login(email: user.email, password: password, remember_me: true)
    cookie = remember_cookie_value

    expect(cookie).to be_present

    Capybara.reset_sessions!
    set_remember_cookie(cookie)

    visit root_path
    expect(page).to have_link("サインアウト")
  end

  it "sends password reset instructions when the email exists" do
    visit new_user_password_path

    expect do
      fill_in "メールアドレス", with: user.email
      click_button "パスワードリセットの手順を送信してください"
    end.to change(ActionMailer::Base.deliveries, :count).by(1)

    expect_password_reset_flash
  end

  it "does not reveal whether an email exists when requesting password reset" do
    visit new_user_password_path

    expect do
      fill_in "メールアドレス", with: "missing@example.com"
      click_button "パスワードリセットの手順を送信してください"
    end.not_to change(ActionMailer::Base.deliveries, :count)

    expect_password_reset_flash
  end

  it "updates the password when visiting the reset form with a valid token" do
    token = fetch_reset_token(user)
    visit edit_user_password_path(reset_password_token: token)

    fill_in "New password", with: "newsecurepassword"
    fill_in "Confirm new password", with: "newsecurepassword"
    click_button "Change my password"

    expect(page).to have_content("Your password has been changed successfully. You are now signed in.")
    expect(page).to have_link("サインアウト")
  end

  it "shows validation errors when the reset form is submitted without passwords" do
    token = fetch_reset_token(user)
    visit edit_user_password_path(reset_password_token: token)

    fill_in "New password", with: ""
    fill_in "Confirm new password", with: ""
    click_button "Change my password"

    expect(page).to have_css("#error_explanation")
    expect(page).to have_content("Password can't be blank")
  end
end

require 'rails_helper'

RSpec.describe "Rule search", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:title_rule) do
    create(
      :rule,
      title: "3秒ルールの基本",
      body: "制限区域に3秒以上滞在すると適用。",
      slug: "title-rule"
    )
  end

  let!(:body_rule) do
    create(
      :rule,
      title: "トラベリング",
      body: "ボール保持中に二歩以上歩くと反則になります。",
      slug: "body-rule"
    )
  end

  let!(:unrelated_rule) do
    create(
      :rule,
      title: "ダブルドリブル",
      body: "ドリブルを再開すると反則です。",
      slug: "unrelated-rule"
    )
  end

  def search_for(keyword)
    visit search_rules_path
    fill_in "q", with: keyword
    click_button "検索"
  end

  it "finds rules whose titles partially match the keyword" do
    search_for("3秒")

    expect(page).to have_link(title_rule.title, href: rule_path(title_rule))
    expect(page).not_to have_link(unrelated_rule.title, href: rule_path(unrelated_rule))
  end

  it "finds rules whose bodies partially match the keyword" do
    search_for("二歩以上")

    expect(page).to have_link(body_rule.title, href: rule_path(body_rule))
    expect(page).not_to have_link(unrelated_rule.title, href: rule_path(unrelated_rule))
  end

  it "shows a message when no rules match" do
    search_for("存在しないルール")

    expect(page).to have_content("該当するルールは見つかりませんでした。")
    expect(page).not_to have_link(title_rule.title, href: rule_path(title_rule))
    expect(page).not_to have_link(body_rule.title, href: rule_path(body_rule))
  end
end

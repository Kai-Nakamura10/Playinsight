require 'rails_helper'

RSpec.describe "Rule explanations", type: :system do
  before do
    driven_by(:rack_test)
  end
  let!(:first_rule) do
    create(
      :rule,
      title: "基本ルール1",
      body: "最初に読むべき説明です。"
    )
  end

  let!(:second_rule) do
    create(
      :rule,
      title: "基本ルール2",
      body: "次の説明が表示されます。"
    )
  end

  it "shows the current rule explanation and the navigation button" do
    visit rule_path(first_rule)

    expect(page).to have_content(first_rule.title)
    expect(page).to have_content(first_rule.body)
    expect(page).to have_link("次のルール →", href: rule_path(second_rule))
  end

  it "moves to the next rule explanation after clicking the button" do
    visit rule_path(first_rule)
    click_link "次のルール →"

    expect(page).to have_current_path(rule_path(second_rule), ignore_query: true)
    expect(page).to have_content(second_rule.title)
    expect(page).to have_content(second_rule.body)
  end
end

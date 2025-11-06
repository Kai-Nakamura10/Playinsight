require "rails_helper"

RSpec.describe Comment, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe "バリデーション" do
    it "body は必須" do
      c = build(:comment, body: nil)
      expect(c).to be_invalid
      expect(c.errors[:body]).to be_present
    end

    it "user は必須" do
      c = build(:comment, user: nil)
      expect(c).to be_invalid
      expect(c.errors[:user]).to be_present
    end

    it "video は必須" do
      c = build(:comment, video: nil)
      expect(c).to be_invalid
      expect(c.errors[:video]).to be_present
    end

    it "timeline は任意（nil 可）" do
      c = build(:comment, timeline: nil)
      expect(c).to be_valid
    end

    it "timeline が存在すれば関連できる" do
      tl = create(:timeline)
      c = build(:comment, timeline: tl)
      expect(c).to be_valid
      c.save!
      expect(c.timeline).to eq tl
    end
  end

  describe "ancestry（ツリー構造）" do
    it "親子関係を作れる" do
      parent = create(:comment, body: "親")
      child  = create(:comment, body: "子", parent: parent)

      expect(child.parent).to eq parent
      expect(parent.children).to include child
      expect(child.ancestors).to eq [parent]
      expect(child.path).to eq [parent, child]
    end

    it "2段以上のネストでも path が繋がる" do
      p = create(:comment, body: "親")
      c = create(:comment, body: "子", parent: p)
      g = create(:comment, body: "孫", parent: c)

      expect(g.ancestors).to eq [p, c]
      expect(g.path.map(&:body)).to eq %w[親 子 孫]
    end
  end

  describe "default_scope（作成日時で昇順）" do
    it "古い→新しいの順で並ぶ" do
      older = travel_to(1.hour.ago) { create(:comment, body: "old") }
      mid   = travel_to(30.minutes.ago) { create(:comment, body: "mid") }
      newer = create(:comment, body: "new")

      expect(Comment.pluck(:body)).to eq %w[old mid new]
    end

    it "unscoped を使えば順序は固定されない（参考）" do
      c1 = create(:comment, body: "a")
      c2 = create(:comment, body: "b")
      expect(Comment.unscoped.order(created_at: :desc).first).to eq c2
    end
  end

  describe "#to_s" do
    it "30文字以内ならそのまま返す" do
      c = build(:comment, body: "あ" * 30)
      expect(c.to_s).to eq("あ" * 30)
    end

    it "30文字超なら省略される" do
      c = build(:comment, body: "あ" * 31)
      expect(c.to_s.length).to be <= 30 + 1 # 省略記号含む
      expect(c.to_s).to include("…").or include("...")
    end
  end

  describe "#formatted_created_at" do
    it 'YYYY-MM-DD HH:MM 形式で返す' do
      time = Time.zone.parse("2025-01-02 03:04")
      c = travel_to(time) { create(:comment) }
      expect(c.formatted_created_at).to eq "2025-01-02 03:04"
    end
  end
end

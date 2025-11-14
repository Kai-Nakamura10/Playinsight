require 'rails_helper'

RSpec.describe Tactic, type: :model do
  describe "バリデーション" do
    it "title と slug があれば有効" do
      tactic = build(:tactic, title: "戦術", slug: "tactic-a")
      expect(tactic).to be_valid
    end

    it "title が空だと無効" do
      tactic = build(:tactic, title: "")
      expect(tactic).not_to be_valid
      expect(tactic.errors[:title]).to be_present
    end

    it "slug が空だと無効" do
      tactic = build(:tactic, slug: "")
      expect(tactic).not_to be_valid
      expect(tactic.errors[:slug]).to be_present
    end

    it "slug が重複すると無効" do
      create(:tactic, slug: "duplicate")
      tactic = build(:tactic, slug: "duplicate")
      expect(tactic).not_to be_valid
      expect(tactic.errors[:slug]).to be_present
    end
  end

  describe "関連" do
    it "video_tactics を dependent: :destroy で保持する" do
      tactic = create(:tactic)
      create(:video_tactic, tactic: tactic)

      expect { tactic.destroy }.to change(VideoTactic, :count).by(-1)
    end

    it "video_tactics 経由で videos にアクセスできる" do
      tactic = create(:tactic)
      video = create(:video)
      create(:video_tactic, tactic: tactic, video: video)

      expect(tactic.videos).to include(video)
    end

    it "success_conditions の dependent オプションが :destroy" do
      association = described_class.reflect_on_association(:success_conditions)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it "failure_patterns の dependent オプションが :destroy" do
      association = described_class.reflect_on_association(:failure_patterns)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe "インスタンスメソッド" do
    it "#success_conditions は steps から配列を返す" do
      tactic = build(:tactic, steps: { "success_conditions" => [ "A", "B" ] })
      expect(tactic.success_conditions).to eq([ "A", "B" ])
    end

    it "#success_conditions は steps が Hash でなければ空配列" do
      tactic = build(:tactic, steps: nil)
      expect(tactic.success_conditions).to eq([])
    end

    it "#common_failures は steps から配列を返す" do
      tactic = build(:tactic, steps: { "common_failures" => [ "失敗例" ] })
      expect(tactic.common_failures).to eq([ "失敗例" ])
    end

    it "#counters_string は nil のとき空文字を返す" do
      tactic = build(:tactic, counters: nil)
      expect(tactic.counters_string).to eq("")
    end
  end

  describe "テキスト入力用アクセサ" do
    it "success_text を与えると改行ごとの配列に整形される" do
      tactic = build(:tactic, steps: nil, success_text: "ライン1\n\n ライン2 ")
      tactic.valid?

      expect(tactic.steps["success_conditions"]).to eq([ "ライン1", "ライン2" ])
    end

    it "success_text が無いと既存配列を compact する" do
      tactic = build(:tactic, steps: { "success_conditions" => [ "実行", "", nil ] }, success_text: nil)
      tactic.valid?

      expect(tactic.steps["success_conditions"]).to eq([ "実行" ])
    end

    it "failure_text も同様に配列へ整形される" do
      tactic = build(:tactic, steps: nil, failure_text: "失敗1\n失敗2\n")
      tactic.valid?

      expect(tactic.steps["common_failures"]).to eq([ "失敗1", "失敗2" ])
    end

    it "failure_text が無いと既存配列を compact する" do
      tactic = build(:tactic, steps: { "common_failures" => [ "失敗", "", nil ] }, failure_text: nil)
      tactic.valid?

      expect(tactic.steps["common_failures"]).to eq([ "失敗" ])
    end

    it "counters_text を与えると前後の空白を取り除いて保存する" do
      tactic = build(:tactic, counters: nil, counters_text: "  速攻で対応  ")
      tactic.valid?

      expect(tactic.counters).to eq("速攻で対応")
    end

    it "steps が nil の場合でも空 Hash から処理される" do
      tactic = build(:tactic, steps: nil)
      tactic.valid?

      expect(tactic.steps).to include("success_conditions", "common_failures")
    end
  end
end

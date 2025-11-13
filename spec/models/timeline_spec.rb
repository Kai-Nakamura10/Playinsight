require 'rails_helper'

RSpec.describe Timeline, type: :model do
  let(:video) { create(:video) }

  describe "validations" do
    subject { build(:timeline, video: video) }

    # kind
    context "kind のバリデーション" do
      it "KINDS に含まれる値なら有効" do
        Timeline::KINDS.each do |k|
          timeline = build(:timeline, video: video, kind: k)
          expect(timeline).to be_valid
        end
      end

      it "KINDS に含まれない値なら無効" do
        timeline = build(:timeline, video: video, kind: "不明")
        expect(timeline).not_to be_valid
        expect(timeline.errors[:kind]).to be_present
      end

      it "kind が blank なら無効" do
        timeline = build(:timeline, video: video, kind: "")
        expect(timeline).not_to be_valid
      end
    end

    # start_seconds
    context "start_seconds のバリデーション" do
      it "0 なら有効" do
        timeline = build(:timeline, video: video, start_seconds: 0)
        expect(timeline).to be_valid
      end

      it "正の値なら有効" do
        timeline = build(:timeline, video: video, start_seconds: 10)
        expect(timeline).to be_valid
      end

      it "-1 なら無効" do
        timeline = build(:timeline, video: video, start_seconds: -1)
        expect(timeline).not_to be_valid
      end

      it "blank なら無効" do
        timeline = build(:timeline, video: video, start_seconds: nil)
        expect(timeline).not_to be_valid
      end
    end

    # end_seconds
    context "end_seconds のバリデーション" do
      it "start_seconds 以上なら有効" do
        timeline = build(:timeline, video: video, start_seconds: 5, end_seconds: 10)
        expect(timeline).to be_valid
      end

      it "start_seconds より小さいと無効" do
        timeline = build(:timeline, video: video, start_seconds: 10, end_seconds: 5)
        expect(timeline).not_to be_valid
      end

      it "blank なら有効" do
        timeline = build(:timeline, video: video, end_seconds: nil)
        expect(timeline).to be_valid
      end
    end

    # title_or_body_present
    context "title_or_body_present カスタムバリデーション" do
      it "title と body が両方空だと無効" do
        timeline = build(:timeline, video: video, title: nil, body: nil)
        expect(timeline).not_to be_valid
        expect(timeline.errors[:base]).to include("タイトルまたは本文のいずれかを入力してください")
      end

      it "title があれば有効" do
        timeline = build(:timeline, video: video, title: "タイトル", body: nil)
        expect(timeline).to be_valid
      end

      it "body があれば有効" do
        timeline = build(:timeline, video: video, title: nil, body: "本文")
        expect(timeline).to be_valid
      end
    end

    # payload_is_hash
    context "payload のバリデーション" do
      it "payload が Hash なら有効" do
        timeline = build(:timeline, video: video, payload: { a: 1 })
        expect(timeline).to be_valid
      end

     it "payload が Hash 以外の場合は自動的に {} に変換される" do
       timeline = build(:timeline, video: video, payload: "abc")
       timeline.validate
       expect(timeline.payload).to eq({})
      end
    end

    # ensure_payload_hash
    context "ensure_payload_hash コールバック" do
      it "payload が nil の場合、自動的に {} をセットする" do
        timeline = build(:timeline, video: video, payload: nil)
        timeline.validate
        expect(timeline.payload).to eq({})
      end
    end
  end

  describe "#to_s" do
    it "title があれば title を返す" do
      timeline = build(:timeline, video: video, title: "タイトル", kind: "質問", start_seconds: 5)
      expect(timeline.to_s).to eq("タイトル")
    end

    it "title がなければ 'kind at Xs' を返す" do
      timeline = build(:timeline, video: video, title: nil, kind: "質問", start_seconds: 5)
      expect(timeline.to_s).to eq("質問 at 5.0s")
    end
  end

  describe "scopes" do
    describe ".order_by_time" do
      it "start_seconds 昇順で返す" do
        t1 = create(:timeline, video: video, start_seconds: 10)
        t2 = create(:timeline, video: video, start_seconds: 5)
        t3 = create(:timeline, video: video, start_seconds: 7)

        expect(Timeline.order_by_time).to eq([ t2, t3, t1 ])
      end
    end

    describe ".hit_at" do
      it "t が start と end の間にあるものを返す" do
        t1 = create(:timeline, video: video, start_seconds: 5, end_seconds: 15)
        t2 = create(:timeline, video: video, start_seconds: 10, end_seconds: 20)
        _t3 = create(:timeline, video: video, start_seconds: 30, end_seconds: 40)

        expect(Timeline.hit_at(12)).to match_array([ t1, t2 ])
      end

      it "end_seconds が nil の場合 start_seconds のみで判定する" do
        t1 = create(:timeline, video: video, start_seconds: 10, end_seconds: nil)
        _t2 = create(:timeline, video: video, start_seconds: 5, end_seconds: nil)

        expect(Timeline.hit_at(10)).to include(t1)
      end

      it "範囲外なら返さない" do
        create(:timeline, video: video, start_seconds: 0, end_seconds: 5)
        create(:timeline, video: video, start_seconds: 10, end_seconds: 15)

        expect(Timeline.hit_at(7)).to be_empty
      end
    end
  end
end

require "rails_helper"

RSpec.describe Video, type: :model do
  include ActiveJob::TestHelper

  describe "バリデーション" do
    it "タイトルは必須" do
      v = build(:video, title: nil)
      expect(v).to be_invalid
      expect(v.errors[:title]).to be_present
    end

    it 'visibility は許可値なら有効' do
      %w[public unlisted private].each do |val|
        expect(build(:video, visibility: val)).to be_valid
      end
    end

    it 'visibility に不正値を代入すると ArgumentError が発生する' do
      v = build(:video)
      expect { v.visibility = "secret" }.to raise_error(ArgumentError, /is not a valid visibility/)
    end

    it 'visibility は nil だと無効' do
      v = build(:video, visibility: nil)
      expect(v).to be_invalid
      expect(v.errors.of_kind?(:visibility, :inclusion)).to be true
    end

    it "duration_seconds はnilまたは0以上の整数" do
      expect(build(:video, duration_seconds: nil)).to be_valid
      expect(build(:video, duration_seconds: 0)).to be_valid
      expect(build(:video, duration_seconds: 10)).to be_valid

      v1 = build(:video, duration_seconds: -1)
      v2 = build(:video, duration_seconds: 1.5)
      expect(v1).to be_invalid
      expect(v2).to be_invalid
    end
  end

  describe "enum/属性の挙動" do
    it "visibility_public? などの判定メソッドが使える（prefix:true）" do
      v = build(:video, visibility: "public")
      expect(v.visibility_public?).to be true
      expect(v.visibility_private?).to be false
    end
  end

  describe "関連" do
    it "ユーザーに属する（必須）" do
      v = build(:video, user: nil)
      expect(v).to be_invalid
      expect(v.errors[:user]).to be_present
    end

    it "dependent: :destroy で関連が消える" do
      video = create(:video)
      vt    = video.video_tactics.create!(tactic: Tactic.create!(title: "t", slug: "t"), display_time: 0)
      tl    = video.timelines.create!(title: "segment", kind: "質問", start_seconds: 0)
      vt2   = video.video_tags.create!(tag: Tag.create!(name: "ball"))
      cm    = video.comments.create!(user: video.user, body: "hi")

      expect { video.destroy }.to change {
        [VideoTactic.count, Timeline.count, VideoTag.count, Comment.count]
      }.from([1,1,1,1]).to([0,0,0,0])

      expect { vt.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { vt2.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { tl.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { cm.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "ActiveStorage" do
    it "file/thumbnail を添付できる" do
      v = create(:video)
      v.file.attach(
        io: StringIO.new("mp4data"),
        filename: "a.mp4",
        content_type: "video/mp4"
      )
      v.thumbnail.attach(
        io: StringIO.new("png"),
        filename: "t.png",
        content_type: "image/png"
      )
      expect(v.file).to be_attached
      expect(v.thumbnail).to be_attached
    end

    it "削除でattachmentが消える" do
      v = create(:video)
      v.file.attach(io: StringIO.new("x"), filename: "a.mp4", content_type: "video/mp4")
      expect { v.destroy }.to change(ActiveStorage::Attachment, :count).by(-1)
    end
  end

  describe "コールバック（ジョブ enqueue）" do
    before { ActiveJob::Base.queue_adapter = :test }

    it "作成時に VideoJob が1回だけenqueueされる" do
      expect {
        create(:video)
      }.to have_enqueued_job(VideoJob).exactly(:once)
    end

    it "更新時には enqueue されない" do
      v = create(:video)
      clear_enqueued_jobs

      expect {
        v.update!(title: "changed")
      }.not_to have_enqueued_job(VideoJob)
    end

    it "ジョブに id が渡される" do
      perform_enqueued_jobs do
        v = create(:video)
        assert_performed_with(job: VideoJob, args: [v.id])
      end
    end
  end
end

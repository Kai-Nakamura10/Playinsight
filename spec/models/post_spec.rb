require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "バリデーション" do
    it "title と content があればもちろん有効" do
      post = build(:post, title: "お知らせ", content: "本文")
      expect(post).to be_valid
    end

    it "バリデーションが無いので空でも保存できる" do
      post = Post.new
      expect(post).to be_valid
    end
  end
end

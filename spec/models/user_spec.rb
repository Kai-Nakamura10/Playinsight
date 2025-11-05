require 'rails_helper'

RSpec.describe User, type: :model do
    describe 'バリデーション' do
        it 'nicknameが必須' do
            user = build(:user, nickname: nil)
            expect(user).to be_invalid
            expect(user.errors[:nickname]).to be_present
        end

        it 'nicknameは一意' do
            create(:user, nickname: 'kai')
            dup = build(:user, nickname: 'kai')
            expect(dup).to be_invalid
            expect(dup.errors[:nickname]).to include('has already been taken').or include('既に使用されています')
        end

        it 'nicknameは10文字まで（10はOK/11はNG）' do
            ok = build(:user, nickname: 'a' * 10)
            ng = build(:user, nickname: 'a' * 11)
            expect(ok).to be_valid
            expect(ng).to be_invalid
            expect(ng.errors[:nickname]).to be_present
        end

        it 'emailは必須&一意' do
            create(:user, email: 'a@example.com')
            u = build(:user, email:'a@example.com')
            expect(u).to be_invalid
            expect(u.errors[:email]).to be_present
        end

        it 'passwordは6文字未満だとNG' do
            u = build(:user, password: 'short', password_confirmation: 'short')
            expect(u).to be_invalid
            expect(u.errors[:password]).to be_present
        end

        it 'password_cofirmationが一致しないとNG' do
            u = build(:user, password: 'password', password_confirmation: 'mismatch')
            expect(u).to be_invalid
            expect(u.errors[:password_confirmation]).to be_present
        end
    end

    describe '関連' do
        it 'videosを複数持てる' do
            user = create(:user)
            video1 = user.videos.create!(title: 'Video 1', description: 'Desc 1')
            video2 = user.videos.create!(title: 'Video 2', description: 'Desc 2')
            expect(user.videos).to match_array([video1, video2])
        end
        
        it 'commentsを複数持てる' do
            user = create(:user)
            comment1 = user.comments.create!(body: 'Comment 1')
            comment2 = user.comments.create!(body: 'Comment 2')
            expect(user.comments).to match_array([comment1, comment2])
        end

        it 'ユーザーが削除されると関連する動画も削除される' do
            user = create(:user)
            video = user.videos.create!(title: 'Video', description: 'Desc')
            expect { user.destroy }.to change { Video.count }.by(-1)
            expect { Video.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'ユーザーが削除されると関連するコメントも削除される' do
            user = create(:user)
            comment = user.comments.create!(body: 'Comment')
            expect { user.destroy }.to change { Comment.count }.by(-1)
            expect { Comment.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
    end

    describe 'デバイスの動作' do
        it '有効なパスワードで認証できる' do
            user = create(:user, password: 'password', password_confirmation: 'password')
            expect(user.valid_password?('password')).to be true
            expect(user.valid_password?('wrong')).to be false
        end

        it '私を覚えていますかで作成日時が設定される' do
            user = create(:user)
            expect { user.remember_me! }.to change { user.remember_created_at }.from(nil)
        end

        it 'パスワードリセットトークンを生成できる' do
            user = create(:user)
            expect { 
              user.send_reset_password_instructions 
              user.reload
            }.to change { user.reset_password_token }.from(nil)
            expect(user.reset_password_sent_at).to be_present
        end
    end
end

# プロジェクト名：『Playinsight』
<img width="500" src="app/assets/images/Frame 6.png"><br>
<br>

# 目次
- [サービス概要](#-サービス概要)
- [サービスURL](#-サービスurl)
- [サービス開発の背景](#-サービス開発の背景)
- [機能紹介](#-機能紹介)
- [技術構成について](#-技術構成について)
  - [使用技術](#使用技術)
  - [ER図](#er図)
  - [画面遷移図](#画面遷移図)<br>
<br>

# サービス概要
バスケットボール初心者のためのルールを解説、事前ケースでの戦術解説、リアルタイム試合分析を行い、<br>ルールや戦術を学ぶことができバスケットボールをより楽しめるようになります。<br>
<br>

# 🌏 サービスURL
### https://playinsight.jp/<br>
<br>

# 📖 サービス開発の背景
私は、学生のころからバスケが好きで、それもあってバスケについて質問される事が多いです。<br>
しかし、「バスケのルールがわからない！」「自分のプレーを客観的に見れない！」という思いでバスケを始めたけど、長続きしなくなって辞めていってしまう人を何人も見てきました。<br>
<br>

そこで私は、「バスケを楽しく続けたい！習慣化させたい！」といった方々のために、バスケ学習兼戦術分析のアプリを開発することとしました。
<br>

まず私はなぜバスケに興味がわかないのか戦術を理解できていないのか、その原因を考えそれらを補う事が出来るアプリを開発する事にしました。<br>
下記内容についてが、私が思うバスケの知識と戦術が定着しない原因の一覧になります。
- 難しい文章を読むのが大変である。
- 試合の中で戦術が使っているかわかりにくい。
- 戦術の種類が多く覚えるのが大変である。<br>
<br>

これらの原因を補うことが出来るアプリ、それが『Playinsight』となっています。<br>
<br>

# 💻 機能紹介

| ユーザー登録 / ログイン |
| :---: | 
| ![play-insight-google-chrome-2026-01-17-18-19-13_jT58qKCo](https://github.com/user-attachments/assets/ecb0f880-8fff-4d83-8c2e-710bcaedc2b0) |
| <p align="left">『ニックネーム』『メールアドレス』『パスワード』『確認用パスワード』を入力してユーザー登録を行います。</p> |
<br>

| 基本ルール解説 |
| :---: | 
| ![play-insight-google-chrome-2026-01-19-20-10-56_EcWQxa5w](https://github.com/user-attachments/assets/b12db2c8-9b6c-48f1-a079-53b824bd99a6) |
| <p align="left">基本ルールがテキストベースで閲覧することが可能。<p> |
<br>

| 戦術表示機能 |
| :---: | 
| [![Image from Gyazo](https://i.gyazo.com/90b60bc6a4cd317eac41d4fc0721c1e7.gif)](https://gyazo.com/90b60bc6a4cd317eac41d4fc0721c1e7) |
| <p align="left">好きなタイミングで戦術表示できます。<p> |
<br>

# 🔧 技術構成について

## 使用技術
| カテゴリ | 技術内容 |
| --- | --- | 
| サーバーサイド | Ruby on Rails 8.0.3・Ruby 3.3.6 |
| フロントエンド | Ruby on Rails・JavaScript |
| CSSフレームワーク | Tailwindcss |
| Web API | OpenAI API(GPT-4) |
| データベースサーバー | PostgreSQL |
| ファイルサーバー | AWS S3 |
| アプリケーションサーバー | Render |
| バージョン管理ツール | GitHub・Git Flow |
<br>

## ER図
<img width="1542" height="933" alt="Playinsight drawio" src="https://github.com/user-attachments/assets/7cbb69b7-3989-4bcf-becc-2d8700c6425d" />
<br>

## 画面遷移図
https://www.figma.com/design/uU4R7IFUSBh8xIay59CnPW/Play-insight?node-id=0-1&t=wBROsEKRLiGlZkO9-1

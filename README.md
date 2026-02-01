# ShiroGuessr iOS

iOS版「白Guessr」- 白色の色当てゲームアプリケーション

## 概要

ShiroGuessrは、微妙に異なる白色の中から正解の色を当てるゲームです。Web版「白Guessr」のiOSネイティブ実装で、2つのゲームモードが楽しめます。

### ゲームモード

1. **クラシックモード**: 8つの白色から正解の色を選択
2. **マップモード**: グラデーションマップ上に正解の色の位置をピン留め

### スクリーンショット

_Coming soon_

## 技術スタック

- **言語**: Swift 6.0+
- **UIフレームワーク**: SwiftUI
- **最小対応OS**: iOS 17.0+
- **デザインシステム**: Material Design 3準拠
- **広告SDK**: Google Mobile Ads SDK (AdMob)
- **ローカライゼーション**: 日本語・英語対応

## プロジェクト構成

```
ShiroGuessr/
├── Models/              # データモデル層
├── Services/            # ビジネスロジック・API通信層
├── Views/
│   ├── Screens/        # 画面コンポーネント
│   └── Components/     # 再利用可能なUIコンポーネント
├── ViewModels/         # MVVM状態管理層
└── Assets.xcassets     # 画像・カラーアセット
```

## アーキテクチャ

### MVVM (Model-View-ViewModel)

- **Model**: データ構造の定義
- **View**: SwiftUIを使用したUI実装
- **ViewModel**: `@Observable`を使用した状態管理

### 状態管理

SwiftUIネイティブの機能を使用:
- `@Observable`: ViewModelの状態管理
- `@State`: Viewローカルの状態
- `@Environment`: 環境変数・依存性注入

### ナビゲーション

- `NavigationStack`を使用したモダンなナビゲーション実装
- Type-safeなルーティング

## デザインガイドライン

### Material Design 3

このプロジェクトは[Material Design 3](https://m3.material.io/)のデザイン原則に従っています。

#### カラーシステム

`ColorSystem.swift`にMaterial Design 3準拠のカラーパレットを定義:
- Primary Colors: メインアクション・重要な要素
- Secondary Colors: サブアクション・補助的な要素
- Tertiary Colors: アクセント・強調
- Surface Colors: カード・コンテナの背景
- Error Colors: エラー表示

#### タイポグラフィ

Material Design 3のタイポグラフィスケールを使用:
- Display: 大きな見出し
- Headline: セクション見出し
- Title: カード・リストアイテムのタイトル
- Body: 本文テキスト
- Label: ボタン・小さなラベル

## セットアップ

### 必要要件

- Xcode 15.0+
- macOS 14.0+
- Swift 6.0+

### インストール

1. リポジトリをクローン
```bash
git clone https://github.com/Kurogoma4D/ShiroGuessr-iOS.git
cd ShiroGuessr-iOS
```

2. ローカライゼーションファイルをXcodeプロジェクトに追加

プロジェクトは日本語と英語のローカライゼーションに対応しています。Xcodeで初めてプロジェクトを開く際、以下の手順でローカライゼーションファイルを追加してください:

```bash
# ローカライゼーション設定スクリプトを実行（手順の確認）
./scripts/add-localization-to-xcode.sh
```

詳細な手順については、[LOCALIZATION.md](LOCALIZATION.md)を参照してください。

**注**: ローカライゼーションファイルが追加されていない場合でもビルドは可能ですが、UI文字列が正しく表示されません。

3. AdMob設定ファイルの準備（本番ビルド時のみ必要）

開発環境ではテスト広告IDが自動的に使用されるため、この手順は**リリースビルド時のみ**必要です。

```bash
# テンプレートファイルをコピー
cp Configurations/Prod.xcconfig.example Configurations/Prod.xcconfig

# エディタで開いて実際のAdMob IDを設定
open Configurations/Prod.xcconfig
```

`Configurations/Prod.xcconfig`に以下の値を設定:
- `ADMOB_APP_ID`: AdMobのアプリID（例: `ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY`）
- `ADMOB_INTERSTITIAL_AD_UNIT_ID`: インタースティシャル広告ユニットID（例: `ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ`）

**重要**: `Configurations/Prod.xcconfig`は`.gitignore`に含まれており、リポジトリにコミットされません。

3. Xcodeでプロジェクトを開く
```bash
open ShiroGuessr.xcodeproj
```

4. Xcode で xcconfig ファイルを設定（初回のみ）

プロジェクト設定で環境別の設定ファイルを指定します:
- Project Navigator でプロジェクトを選択
- ShiroGuessr target を選択
- Info タブを開く
- Configurations セクションで:
  - Debug: `Configurations/Dev.xcconfig`
  - Release: `Configurations/Prod.xcconfig`

5. ビルドして実行 (⌘R)

### 環境切り替え

プロジェクトは開発環境（dev）と本番環境（prod）を自動的に切り替えます。

- **Debug ビルド**: テスト広告IDを使用（`Configurations/Dev.xcconfig`）
- **Release ビルド**: 本番広告IDを使用（`Configurations/Prod.xcconfig`）

Xcodeのスキーム設定で使用される環境が決まります:
- Run/Test/Profile: Debug（開発環境）
- Archive: Release（本番環境）

開発中は特に設定なしでテスト広告が表示されます。リリースビルドを作成する際は、必ず`Configurations/Prod.xcconfig`を作成してください。

## ゲームルール

### 基本ルール

- 5ラウンド制のゲーム
- 各ラウンドで目標の白色が表示される
- 制限時間内に正解の色を選択または位置を指定
- 距離が近いほど高得点（最大1000点/ラウンド）
- 全ラウンドの合計スコアを競う（最大5000点）

### スコア計算

スコアは目標色と選択色のマンハッタン距離に基づいて計算されます。

```
distance = |targetR - selectedR| + |targetG - selectedG| + |targetB - selectedB|
score = max(0, 1000 - distance * 30)
```

### 星評価

- 5つ星: 距離0-5
- 4つ星: 距離6-10
- 3つ星: 距離11-20
- 2つ星: 距離21-40
- 1つ星: 距離41以上

## 機能一覧

### ゲーム機能

- クラシックモード（8色選択）
- マップモード（グラデーションマップ+タイマー）
- スコア計算とラウンド結果表示
- 最終結果画面

### シェア機能

- ゲーム結果のテキストシェア
- クリップボードへのコピー
- SNS投稿対応
- Universal Links対応（`https://shiro-guessr.pages.dev/ios`）

### UI/UX

- Material Design 3準拠のデザイン
- スムーズなアニメーション
- レスポンシブデザイン（iPhone/iPad対応）
- ダークモード非対応（白色ゲームのため）

### 広告機能

- インタースティシャル広告（ゲーム再プレイ時）
- 開発/本番環境の自動切り替え
- テスト広告による安全な開発環境

### 多言語対応

- 日本語・英語の完全ローカライゼーション
- デバイスの言語設定に自動対応
- 型安全な文字列管理（LocalizationService）
- 詳細は[LOCALIZATION.md](LOCALIZATION.md)を参照

## 開発

### テスト

テストの実行:

```bash
# すべてのテストを実行
xcodebuild test -scheme ShiroGuessr -destination 'platform=iOS Simulator,name=iPhone 15'

# 特定のテストクラスを実行
xcodebuild test -scheme ShiroGuessr -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:ShiroGuessrTests/ColorServiceTests
```

### ブランチ戦略

- `main`: 安定版
- `issue-*`: 各issue対応用のfeatureブランチ

### コーディング規約

- Swift公式のコーディングスタイルガイドに準拠
- Material Design 3のデザイン原則に従ったUI実装
- DocCスタイルのドキュメントコメント

### パフォーマンス最適化

- `@Observable`による効率的な状態管理
- LazyStacksによる遅延レンダリング
- Canvasによる効率的なマップ描画
- 不要な再描画の削減

## 参考リンク

- [Web版リポジトリ](https://github.com/Kurogoma4D/shiro-guessr)
- [Material Design 3](https://m3.material.io/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)

## ライセンス

MIT License

## 作者

Kurogoma4D

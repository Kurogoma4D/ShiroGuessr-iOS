# ShiroGuessr iOS

iOS版「白Guessr」- 位置当てゲームアプリケーション

## 概要

ShiroGuessrは、Web版「白Guessr」のiOSネイティブ実装です。ユーザーが表示された場所の画像から実際の位置を推測するゲームです。

## 技術スタック

- **言語**: Swift 6.0+
- **UIフレームワーク**: SwiftUI
- **最小対応OS**: iOS 17.0+
- **デザインシステム**: Material Design 3準拠

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

2. Xcodeでプロジェクトを開く
```bash
open ShiroGuessr.xcodeproj
```

3. ビルドして実行 (⌘R)

## 開発

### ブランチ戦略

- `main`: 安定版
- `issue-*`: 各issue対応用のfeatureブランチ

### コーディング規約

- Swift公式のコーディングスタイルガイドに準拠
- SwiftLintによる静的解析
- Material Design 3のデザイン原則に従ったUI実装

## 参考リンク

- [Web版リポジトリ](https://github.com/Kurogoma4D/shiro-guessr)
- [Material Design 3](https://m3.material.io/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)

## ライセンス

MIT License

## 作者

Kurogoma4D

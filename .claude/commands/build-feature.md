# Build iOS Feature

ユーザーから指示された機能を、このプロジェクトのアーキテクチャに従って構築してください。

## 機能の説明

$ARGUMENTS

## アーキテクチャ概要

このプロジェクトは **MVVM + Service + Repository** アーキテクチャを採用しています。

```
Screen (View)
  └─ @State ViewModel (@Observable, @MainActor)
      └─ Service (actor)
          └─ @Dependency Repository (@DependencyClient)
              └─ Entity (struct)
```

### レイヤー構成

| レイヤー | 役割 | 配置先 |
|---------|------|--------|
| **Entity** | ドメインモデル（値型） | `OctoDeck/Entity/` |
| **Repository** | データアクセス抽象化・API呼び出し | `OctoDeck/Repository/` |
| **Service** | ビジネスロジックのオーケストレーション | `OctoDeck/Service/` |
| **ViewModel** | UIの状態管理 | `OctoDeck/ViewModel/` |
| **Screen** | フルスクリーンのView | `OctoDeck/Screen/` |
| **Component** | 再利用可能なUIパーツ | `OctoDeck/Component/` |
| **Helper** | インフラ・ユーティリティ | `OctoDeck/Helper/` |

## 各レイヤーの実装パターン

### 1. Entity

- `struct` で定義（値型）
- `Equatable`, `Identifiable` に準拠
- Preview用のstubデータを `extension` で定義

```swift
import Foundation

struct {FeatureName}: Equatable, Identifiable {
    let id: String
    // プロパティ
}

extension {FeatureName} {
    static let stub0 = {FeatureName}(
        id: "stub0"
        // stubデータ
    )

    static let stubs = [stub0]
}
```

### 2. Repository

- `@DependencyClient` マクロで定義（swift-dependencies）
- `nonisolated struct` として宣言
- 操作は `@Sendable` クロージャとして定義
- `DependencyKey` でライブ実装を提供
- `TestDependencyKey` でプレビュー/テスト用スタブを提供
- `DependencyValues` に登録

```swift
import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
nonisolated struct {FeatureName}Repository {
    var list{FeatureName}s: @Sendable () async throws -> [{FeatureName}]
    var get{FeatureName}: @Sendable (_ id: {FeatureName}.ID) async throws -> {FeatureName}
}

nonisolated extension {FeatureName}Repository: DependencyKey {
    static let liveValue = {FeatureName}Repository(
        list{FeatureName}s: {
            let client = try await Client.build()
            let response = try await client.get{FeatureName}s()
            switch response {
            case .ok(let okResponse):
                // レスポンスをEntityに変換
                return try okResponse.body.json.items.map { make{FeatureName}(from: $0) }
            case .undocumented(let statusCode, let payload):
                throw {FeatureName}RepositoryError.apiError(statusCode)
            }
        },
        get{FeatureName}: { id in
            let client = try await Client.build()
            let response = try await client.get{FeatureName}(path: .init(id: id))
            switch response {
            case .ok(let okResponse):
                return try make{FeatureName}(from: okResponse.body.json.item)
            case .undocumented(let statusCode, let payload):
                throw {FeatureName}RepositoryError.apiError(statusCode)
            }
        }
    )
}

nonisolated extension {FeatureName}Repository: TestDependencyKey {
    static let previewValue = {FeatureName}Repository(
        list{FeatureName}s: {
            {FeatureName}.stubs
        },
        get{FeatureName}: { _ in
            .stub0
        }
    )
}

nonisolated extension DependencyValues {
    var {featureName}Repository: {FeatureName}Repository {
        get { self[{FeatureName}Repository.self] }
        set { self[{FeatureName}Repository.self] = newValue }
    }
}
```

### 3. Repository Error

- ドメイン固有のエラー型を `enum` で定義

```swift
enum {FeatureName}RepositoryError: Error {
    case apiError(_ statusCode: Int)
}
```

### 4. Service

- `final actor` として定義（スレッドセーフ）
- `@Dependency` でRepositoryを注入
- ビジネスロジックのオーケストレーションを担当

```swift
import Dependencies

final actor {FeatureName}Service {
    @Dependency(\.{featureName}Repository) private var {featureName}Repository

    func get{FeatureName}s() async throws -> [{FeatureName}] {
        try await {featureName}Repository.list{FeatureName}s()
    }

    func get{FeatureName}(id: String) async throws -> {FeatureName} {
        try await {featureName}Repository.get{FeatureName}(id: id)
    }
}
```

### 5. ViewModel

- `@Observable` マクロ + `@MainActor` で定義
- `final class` として宣言
- Serviceをプロパティとして保持（直接初期化）
- `isLoading` で読み込み状態を管理
- `private(set)` で外部からの変更を制限
- UIイベントに対応するメソッドを公開

```swift
import Observation

@Observable
@MainActor
final class {FeatureName}ViewModel {
    private(set) var items: [{FeatureName}] = []
    private(set) var isLoading: Bool = false
    var selectedItem: {FeatureName}?

    private let service = {FeatureName}Service()

    func onAppear() async {
        isLoading = true
        defer {
            isLoading = false
        }
        await refresh()
    }

    func onRefresh() async {
        isLoading = true
        defer {
            isLoading = false
        }
        await refresh()
    }

    private func refresh() async {
        do {
            items = try await service.get{FeatureName}s()
        } catch {
            print(error)
        }
    }

    func onItemSelected(_ item: {FeatureName}) {
        selectedItem = item
    }
}
```

### 6. Screen (View)

- `struct` で `View` に準拠
- `@State private var viewModel` でViewModelを保持
- `.task` modifier で `onAppear` を呼び出し
- `@ViewBuilder` でコンテンツを状態に応じて分岐
- `.sheet(item:)` でモーダル表示
- `#Preview` ブロックを必ず追加

```swift
import SwiftUI

struct {FeatureName}Screen: View {
    @State private var viewModel = {FeatureName}ViewModel()

    var body: some View {
        content
            .task {
                await viewModel.onAppear()
            }
            .sheet(item: $viewModel.selectedItem) { item in
                // 詳細画面
            }
    }

    @ViewBuilder
    var content: some View {
        if viewModel.items.isEmpty && viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.items.isEmpty {
            ContentUnavailableView(
                "No Items",
                systemImage: "tray"
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ScrollView {
                // コンテンツ
            }
            .refreshable {
                await viewModel.onRefresh()
            }
        }
    }
}

#Preview {
    {FeatureName}Screen()
}
```

### 7. テスト

Service と ViewModel の両方でテストを書きます。

#### Service テスト (`OctoDeckTests/Service/{FeatureName}ServiceTests.swift`)

- `@MainActor struct` で定義
- `withDependencies` でRepositoryをモック
- `@Test("説明")` 形式（Swift Testing フレームワーク）
- `#expect` でアサーション

```swift
import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct {FeatureName}ServiceTests {
    @Test("{FeatureName}が正しく返却される")
    func testGet{FeatureName}sSuccess() async throws {
        let expected = {FeatureName}.stubs

        let service = withDependencies {
            $0.{featureName}Repository.list{FeatureName}s = {
                expected
            }
        } operation: {
            {FeatureName}Service()
        }

        #expect(try await service.get{FeatureName}s() == expected)
    }

    @Test("{FeatureName}の取得に失敗する")
    func testGet{FeatureName}sFailure() async throws {
        let service = withDependencies {
            $0.{featureName}Repository.list{FeatureName}s = {
                throw {FeatureName}RepositoryError.apiError(500)
            }
        } operation: {
            {FeatureName}Service()
        }

        await #expect(throws: {FeatureName}RepositoryError.self) {
            try await service.get{FeatureName}s()
        }
    }
}
```

#### ViewModel テスト (`OctoDeckTests/ViewModel/{FeatureName}ViewModelTests.swift`)

```swift
import Dependencies
import Foundation
import Testing
@testable import OctoDeck

@MainActor
struct {FeatureName}ViewModelTests {
    @Test("onAppearでデータが正しく取得される")
    func testOnAppearSuccess() async throws {
        let expected = {FeatureName}.stubs

        let viewModel = withDependencies {
            $0.{featureName}Repository.list{FeatureName}s = {
                expected
            }
        } operation: {
            {FeatureName}ViewModel()
        }

        await viewModel.onAppear()

        #expect(viewModel.items == expected)
        #expect(viewModel.isLoading == false)
    }

    @Test("初期状態が正しい")
    func testInitialState() async throws {
        let viewModel = withDependencies {
            $0.{featureName}Repository.list{FeatureName}s = {
                {FeatureName}.stubs
            }
        } operation: {
            {FeatureName}ViewModel()
        }

        #expect(viewModel.items == [])
        #expect(viewModel.isLoading == false)
        #expect(viewModel.selectedItem == nil)
    }
}
```

## 実装手順

以下の順序で実装してください:

1. **Entity** を作成（stubデータ含む）
2. **RepositoryError** を作成
3. **Repository** を作成（`@DependencyClient`, `DependencyKey`, `TestDependencyKey`, `DependencyValues`）
4. **Service** を作成
5. **ViewModel** を作成
6. **Screen** を作成
7. **Component** を必要に応じて作成
8. **Service テスト** を作成
9. **ViewModel テスト** を作成

## 重要な規約

- **ファイルヘッダー**: 各ファイルの先頭にXcode標準のコメント（ファイル名、プロジェクト名）を含める
- **命名規則**:
  - Screen: `{Feature}Screen`
  - ViewModel: `{Feature}ViewModel`
  - Service: `{Feature}Service`
  - Repository: `{Domain}Repository`
  - Error: `{Domain}RepositoryError`
  - Component: `{Name}View`
- **Concurrency**: `async/await` を使用。Repository操作は `async throws`
- **UI フレームワーク**: SwiftUI のみ（UIKit は使用しない）
- **ダークテーマ**: `.preferredColorScheme(.dark)` がルートで設定済み
- **テストフレームワーク**: Swift Testing (`import Testing`)。XCTest は使用しない
- **テスト記述**: `@Test("日本語の説明")` 形式
- **ナビゲーション**: SwiftUI ネイティブ（`NavigationSplitView`, `TabView`, `.sheet`）
- **パッケージ依存**: `swift-dependencies` (DI), `NukeUI` (画像), `Lottie` (アニメーション)
- **OpenAPI**: API クライアントは `Client.build()` でインスタンス化。OpenAPI Generator で自動生成されたコードを使用

## 注意事項

- 既存のEntityやRepositoryを再利用できる場合は新規作成せず再利用する
- 実装前にプロジェクト内の既存コードを確認し、パターンの一貫性を保つ
- Xcodeプロジェクトファイルへのファイル追加は不要（フォルダ参照で自動認識される）

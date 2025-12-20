# OctoDeck iOS アーキテクチャ

## 概要

OctoDeck は GitHub のコントリビューション情報をカード形式で表示し、コミュニティ内でカードを交換できる iOS アプリケーションです。

本アプリケーションは **MVVM + Service + Repository** パターンを採用しており、関心の分離と依存性注入（DI）によるテスタビリティを重視した設計となっています。

---

## 全体アーキテクチャ

```mermaid
flowchart TB
    subgraph Presentation["プレゼンテーション層"]
        App[OctoDeckApp]
        Screen[Screen]
        ViewModel[ViewModel]
        Component[Component]
    end

    subgraph Domain["ドメイン層"]
        Service[Service]
        Entity[Entity]
    end

    subgraph Data["データ層"]
        Repository[Repository]
        APIClient[API Client]
        Keychain[Keychain / UserDefaults]
    end

    subgraph External["外部"]
        Backend[Backend API]
        GitHubAPI[GitHub API]
    end

    App --> Screen
    Screen --> ViewModel
    Screen --> Component
    ViewModel --> Service
    Service --> Repository
    Service --> Entity
    Repository --> APIClient
    Repository --> Keychain
    APIClient --> Backend
    Repository --> GitHubAPI
```

---

## レイヤー構成

### 1. プレゼンテーション層 (Presentation Layer)

UI と UI の状態管理を担当するレイヤーです。SwiftUI と Observation framework を使用しています。

```mermaid
flowchart TB
    subgraph ViewModels["ViewModel"]
        ContentVM[ContentViewModel]
        MyDeckVM[MyDeckViewModel]
        CommunityListVM[CommunityListViewModel]
        CommunityDetailVM[CommunityDetailViewModel]
        CardDetailVM[CardDetailViewModel]
        SettingVM[SettingViewModel]
    end

    subgraph Screens["Screen"]
        ContentScreen
        MyDeckScreen
        CommunityScreen
        CommunityListScreen
        CommunityDetailScreen
        CardDetailScreen
        SettingScreen
    end

    subgraph Components["Component"]
        CardView
        CardStackView
        CardIssueView
        StatisticView
        IdenticonView
        LoginView
        SafariView
        CompletedView
        LottieView
    end

    ContentScreen --> ContentVM
    MyDeckScreen --> MyDeckVM
    CommunityListScreen --> CommunityListVM
    CommunityDetailScreen --> CommunityDetailVM
    CardDetailScreen --> CardDetailVM
    SettingScreen --> SettingVM

    ContentScreen --> MyDeckScreen
    ContentScreen --> CommunityScreen
    ContentScreen --> SettingScreen
    CommunityScreen --> CommunityListScreen
    CommunityScreen --> CommunityDetailScreen
    MyDeckScreen --> CardDetailScreen

    MyDeckScreen --> CardView
    MyDeckScreen --> CardStackView
    CardDetailScreen --> CardView
    CardDetailScreen --> StatisticView
```

| 名前          | 責務                                                                                           |
| ------------- | ---------------------------------------------------------------------------------------------- |
| **Screen**    | 画面単位のビュー。ViewModel を保持し、ユーザーインタラクションを処理                           |
| **ViewModel** | UI の状態管理。`@Observable` マクロで状態を公開し、`@MainActor` でメインスレッドでの実行を保証 |
| **Component** | 再利用可能な UI コンポーネント。状態を持たず、親から渡されたデータを表示                       |

---

### 2. ドメイン層 (Domain Layer)

ビジネスロジックとドメインモデルを担当するレイヤーです。

```mermaid
flowchart TB
    subgraph Services["Service"]
        ContentSvc[ContentService]
        MyDeckSvc[MyDeckService]
        CommunityListSvc[CommunityListService]
        CommunityDetailSvc[CommunityDetailService]
        CardDetailSvc[CardDetailService]
        SettingSvc[SettingService]
    end

    subgraph Entities["Entity"]
        Card
        User
        Community
        Statistic
        Contribution
        Language
        Identicon
    end

    ContentSvc --> Card
    ContentSvc --> User
    MyDeckSvc --> Card
    CommunityListSvc --> Community
    CommunityDetailSvc --> Card
    CommunityDetailSvc --> Community
    CardDetailSvc --> Card
    CardDetailSvc --> Statistic
```

| 名前        | 責務                                                                             |
| ----------- | -------------------------------------------------------------------------------- |
| **Service** | ビジネスロジックの実装。`actor` として定義され、スレッドセーフなデータ処理を実現 |
| **Entity**  | ドメインモデル。`Card`, `User`, `Community`, `Statistic` など                    |

---

### 3. データ層 (Data Layer)

外部データソースとの通信を担当するレイヤーです。

```mermaid
flowchart TB
    subgraph Repositories["Repository"]
        CardRepo[CardRepository]
        CommunityRepo[CommunityRepository]
        StatisticRepo[StatisticRepository]
        GitHubAuthRepo[GitHubAuthRepository]
    end

    subgraph Infrastructure["Infrastructure"]
        Client[API Client<br/>OpenAPI Generated]
        Keychain[KeychainHelper]
        UserDef[UserDefaults]
    end

    subgraph External["External APIs"]
        Backend[OctoDeck Backend]
        GitHub[GitHub OAuth API]
    end

    CardRepo --> Client
    CommunityRepo --> Client
    StatisticRepo --> Client
    GitHubAuthRepo --> Keychain
    GitHubAuthRepo --> UserDef
    GitHubAuthRepo --> GitHub

    Client --> Backend
```

| 名前               | 責務                                                           |
| ------------------ | -------------------------------------------------------------- |
| **Repository**     | データアクセスの抽象化。`@DependencyClient` マクロで DI に対応 |
| **API Client**     | OpenAPI Generator で生成。バックエンド API との通信            |
| **KeychainHelper** | アクセストークンの安全な保存                                   |

---

## 依存性注入 (Dependency Injection)

[swift-dependencies](https://github.com/pointfreeco/swift-dependencies) を使用して依存性注入を実現しています。

```mermaid
flowchart LR
    subgraph DI["Dependency Container"]
        DV[DependencyValues]
    end

    subgraph Repos["Repositories"]
        CardR[cardRepository]
        CommunityR[communityRepository]
        StatisticR[statisticRepository]
        GitHubAuthR[gitHubAuthRepository]
    end

    subgraph Implementations["Implementations"]
        Live[liveValue<br/>本番用]
        Preview[previewValue<br/>プレビュー・テスト用]
    end

    DV --> CardR
    DV --> CommunityR
    DV --> StatisticR
    DV --> GitHubAuthR

    CardR --> Live
    CardR --> Preview
```

各 Repository は以下の実装を持ちます：

- **liveValue**: 本番環境で使用される実際の API 呼び出し
- **previewValue**: SwiftUI プレビューおよびテストで使用されるモック

---

## データフロー

### 認証フロー

```mermaid
sequenceDiagram
    participant User as ユーザー
    participant Screen as ContentScreen
    participant VM as ContentViewModel
    participant Svc as ContentService
    participant Repo as GitHubAuthRepository
    participant GitHub as GitHub OAuth

    User->>Screen: サインインボタンタップ
    Screen->>VM: onSignInButtonTapped()
    VM->>Svc: getSignInURL()
    Svc->>Repo: getSignInURL()
    Repo-->>Svc: URL
    Svc-->>VM: URL
    VM-->>Screen: SafariView を表示

    User->>GitHub: GitHub で認証
    GitHub-->>Screen: Callback URL (code 付き)
    Screen->>VM: handleURL(url)
    VM->>Svc: signIn(code)
    Svc->>Repo: signIn(code)
    Repo->>GitHub: アクセストークン取得
    GitHub-->>Repo: Access Token
    Repo->>Repo: Keychain に保存
    Repo-->>Svc: userID
    Svc-->>VM: userID
    VM->>VM: refresh()
    VM-->>Screen: 認証済み状態に更新
```

### カード取得フロー

```mermaid
sequenceDiagram
    participant Screen as MyDeckScreen
    participant VM as MyDeckViewModel
    participant Svc as MyDeckService
    participant Repo as CardRepository
    participant Client as API Client
    participant Backend as Backend

    Screen->>VM: onAppear()
    VM->>VM: isLoading = true

    par 並列取得
        VM->>Svc: getMyCard()
        Svc->>Repo: getMyCard()
        Repo->>Client: getMyCard()
        Client->>Backend: GET /users/me/card
        Backend-->>Client: Card JSON
        Client-->>Repo: Response
        Repo-->>Svc: Card
        Svc-->>VM: Card
    and
        VM->>Svc: getCardsInMyDeck()
        Svc->>Repo: listCards()
        Repo->>Client: getCards()
        Client->>Backend: GET /cards
        Backend-->>Client: Cards JSON
        Client-->>Repo: Response
        Repo-->>Svc: [Card]
        Svc-->>VM: [Card]
    end

    VM->>VM: isLoading = false
    VM-->>Screen: UI 更新
```

---

## Entity 構成

```mermaid
classDiagram
    class Card {
        +String id
        +String userName
        +String fullName
        +URL? iconUrl
        +Identicon identicon
        +Language mostUsedLanguage
    }

    class User {
        +String id
        +String userName
        +String fullName
        +URL? avatarUrl
    }

    class Community {
        +String id
        +String name
        +Date startAt
        +Date endAt
    }

    class Statistic {
        +[Contribution] contributions
        +Int totalContribution
        +Language mostUsedLanguage
        +ContributionDetail contributionDetail
    }

    class Identicon {
        +DomainColor color
        +[Int] blocks
    }

    class Language {
        +String name
        +DomainColor color
    }

    class Contribution {
        +Date date
        +Int count
    }

    class ContributionDetail {
        +Int reviewCount
        +Int commitCount
        +Int pullRequestCount
        +Int issueCount
    }

    class HighlightedCard {
        +Card bestReviewer
        +Card bestContributor
        +Card bestCommitter
        +Card bestPullRequester
        +Card bestIssuer
    }

    Card --> Identicon
    Card --> Language
    Statistic --> Contribution
    Statistic --> Language
    Statistic --> ContributionDetail
    HighlightedCard --> Card
```

---

## ディレクトリ構成

```
OctoDeck/
├── OctoDeckApp.swift          # アプリケーションエントリーポイント
├── Screen/                    # 画面（View）
│   ├── ContentScreen.swift
│   ├── MyDeckScreen.swift
│   ├── CommunityScreen.swift
│   ├── CommunityListScreen.swift
│   ├── CommunityDetailScreen.swift
│   ├── CardDetailScreen.swift
│   └── SettingScreen.swift
├── ViewModel/                 # ViewModel
│   ├── ContentViewModel.swift
│   ├── MyDeckViewModel.swift
│   └── ...
├── Service/                   # ビジネスロジック
│   ├── ContentService.swift
│   ├── MyDeckService.swift
│   └── ...
├── Repository/                # データアクセス
│   ├── CardRepository.swift
│   ├── CommunityRepository.swift
│   ├── StatisticRepository.swift
│   └── GitHubAuthRepository.swift
├── Entity/                    # ドメインモデル
│   ├── Card.swift
│   ├── User.swift
│   ├── Community.swift
│   └── ...
├── Component/                 # 再利用可能 UI コンポーネント
│   ├── CardView.swift
│   ├── CardStackView.swift
│   └── ...
├── Helper/                    # ユーティリティ
│   ├── APIClient.swift
│   ├── APIAuthMiddleware.swift
│   ├── KeychainHelper.swift
│   └── ...
└── openapi/                   # OpenAPI 定義
    └── openapi.yaml
```

---

## 技術スタック

| カテゴリ           | 技術                                                                        |
| ------------------ | --------------------------------------------------------------------------- |
| UI フレームワーク  | SwiftUI                                                                     |
| 状態管理           | Observation framework (`@Observable`)                                       |
| 依存性注入         | [swift-dependencies](https://github.com/pointfreeco/swift-dependencies)     |
| API クライアント   | [swift-openapi-generator](https://github.com/apple/swift-openapi-generator) |
| 認証               | GitHub OAuth 2.0                                                            |
| セキュアストレージ | Keychain Services                                                           |
| アニメーション     | Lottie                                                                      |

---

## 設計原則

1. **関心の分離**: 各レイヤーは単一の責務を持ち、他のレイヤーの詳細を知らない
2. **依存性逆転**: Service は Repository のプロトコルに依存し、具体的な実装には依存しない
3. **テスタビリティ**: DI により Repository をモックに差し替え可能
4. **スレッドセーフ**: Service は `actor` として実装され、データ競合を防止
5. **型安全**: OpenAPI から生成された型により API 呼び出しの型安全性を保証

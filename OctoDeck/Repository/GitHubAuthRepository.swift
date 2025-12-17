//
//  GitHubAuthRepository.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/15.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
nonisolated struct GitHubAuthRepository {
    /// SignIn して、UserIDを返却
    var signIn: @Sendable (_ code: String) async throws -> String
    /// SignOut して、UserIDを返却
    var signOut: @Sendable () async throws -> String
    var getAccessToken: @Sendable () async throws -> String
    var getSignInURL: @Sendable () async throws -> URL
    var getAuthenticatedUser: @Sendable () async throws -> User
}

nonisolated extension GitHubAuthRepository: DependencyKey {
    static let liveValue = GitHubAuthRepository(
        signIn: { code in
            let accessToken = try await fetchAccessToken(code: code)
            let user = try await getUser(accessToken: accessToken)

            UserDefaults.standard.set(user.id, forKey: "githubUserId")

            guard let accessTokenData = accessToken.data(using: .utf8) else {
                throw GitHubAuthRepositoryError.invalidResponse
            }

            try KeychainHelper.write(accessTokenData, service: "Octo Deck", account: "\(user.id) GitHub OAuth2 Access Token")

            return user.id.description
        },
        signOut: {
            guard let userId = UserDefaults.standard.string(forKey: "githubUserId") else {
                throw GitHubAuthRepositoryError.userIdNotFound
            }

            try KeychainHelper.delete(service: "Octo Deck", account: "\(userId) GitHub OAuth2 Access Token")
            UserDefaults.standard.removeObject(forKey: "githubUserId")

            return userId
        },
        getAccessToken: {
            guard let userId = UserDefaults.standard.string(forKey: "githubUserId") else {
                throw GitHubAuthRepositoryError.userIdNotFound
            }

            return try KeychainHelper.read(service: "Octo Deck", account: "\(userId) GitHub OAuth2 Access Token")
        },
        getSignInURL: {
            let clientID = try loadGitHubAppInfo().clientID
            let callbackURL = "https://octodeck.furari.co/app/github/oauth/callback"
            guard let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID)&redirect_uri=\(callbackURL)") else {
                throw GitHubAuthRepositoryError.failedToLoadSignInURL
            }
            return url
        },
        getAuthenticatedUser: {
            guard let userId = UserDefaults.standard.string(forKey: "githubUserId") else {
                throw GitHubAuthRepositoryError.userIdNotFound
            }

            let accessToken = try KeychainHelper.read(service: "Octo Deck", account: "\(userId) GitHub OAuth2 Access Token")

            let response = try await getUser(accessToken: accessToken)

            let user = User(
                id: response.id.description,
                userName: response.login,
                fullName: response.name
            )

            return user
        }
    )
}

nonisolated extension GitHubAuthRepository: TestDependencyKey {
    static let previewValue = GitHubAuthRepository(
        signIn: { _ in
            ""
        },
        signOut: {
            ""
        },
        getAccessToken: {
            ""
        },
        getSignInURL: {
            URL(string: "https://octodeck.furari.co")!
        },
        getAuthenticatedUser: {
            .stub0
        }
    )
}

nonisolated extension DependencyValues {
    var gitHubAuthRepository: GitHubAuthRepository {
        get { self[GitHubAuthRepository.self] }
        set { self[GitHubAuthRepository.self] = newValue }
    }
}

nonisolated extension GitHubAuthRepository {
    struct GetAccessTokenRequest: Encodable {
        let clientId: String
        let clientSecret: String
        let code: String
    }

    struct GetAccessTokenResponse: Decodable {
        let accessToken: String
    }

    struct GitHubUser: Decodable {
        let id: Int
        let login: String
        let name: String
    }

    private static func loadGitHubAppInfo() throws -> (clientID: String, clientSecret: String) {
        guard
            let plistPath = Bundle.main.path(forResource: "GitHubApp_Info", ofType: "plist"),
            let plistData = FileManager.default.contents(atPath: plistPath),
            let plist = try PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: Any],
            let clientID = plist["GITHUB_APP_CLIENT_ID"] as? String,
            let clientSecret = plist["GITHUB_APP_CLIENT_SECRET"] as? String
        else {
            throw GitHubAuthRepositoryError.missingConfiguration
        }
        return (clientID, clientSecret)
    }

    private static func fetchAccessToken(code: String) async throws -> String {
        guard let url = URL(string: "https://github.com/login/oauth/access_token") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let gitHubAppInfo = try loadGitHubAppInfo()
        let clientID = gitHubAppInfo.clientID
        let clientSecret = gitHubAppInfo.clientSecret

        let requestBody = GetAccessTokenRequest(
            clientId: clientID,
            clientSecret: clientSecret,
            code: code
        )

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        let requestBodyData = try encoder.encode(requestBody)
        request.httpBody = requestBodyData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard
            let statusCode = (response as? HTTPURLResponse)?.statusCode,
            statusCode >= 200 && statusCode < 299
        else {
            throw GitHubAuthRepositoryError.invalidResponse
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let responseBody = try decoder.decode(GetAccessTokenResponse.self, from: data)
        let accessToken = responseBody.accessToken

        return accessToken
    }

    private static func getUser(accessToken: String) async throws -> GitHubUser {
        guard let url = URL(string: "https://api.github.com/user") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard
            let statusCode = (response as? HTTPURLResponse)?.statusCode,
            statusCode >= 200 && statusCode < 299
        else {
            throw GitHubAuthRepositoryError.invalidResponse
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let user = try decoder.decode(GitHubUser.self, from: data)

        return user
    }
}

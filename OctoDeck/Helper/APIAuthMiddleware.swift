//
//  APIAuthMiddleware.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Foundation
import HTTPTypes
import OpenAPIRuntime

final class APIAuthMiddleware: ClientMiddleware {
    func intercept(
        _ request: HTTPTypes.HTTPRequest,
        body: OpenAPIRuntime.HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPTypes.HTTPRequest, OpenAPIRuntime.HTTPBody?, URL) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?)
    ) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) {
        guard let userId = UserDefaults.standard.string(forKey: "githubUserId") else {
            throw GitHubAuthRepositoryError.userIdNotFound
        }
        let accessToken = try KeychainHelper.read(service: "Octo Deck", account: "\(userId) GitHub OAuth2 Access Token")

        var request = request
        request.headerFields.append(
            .init(
                name: .init("Authorization")!,
                value: "Bearer \(accessToken)"
            )
        )

        return try await next(request, body, baseURL)
    }
}

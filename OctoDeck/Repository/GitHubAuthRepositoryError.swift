//
//  GitHubAuthRepositoryError.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/15.
//

enum GitHubAuthRepositoryError: Error {
    case invalidResponse
    case missingConfiguration
    case userIdNotFound
    case failedToLoadSignInURL
}

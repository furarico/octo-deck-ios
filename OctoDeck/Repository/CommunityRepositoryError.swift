//
//  CommunityRepositoryError.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/18.
//

enum CommunityRepositoryError: Error {
    case apiError(_ statusCode: Int)
}


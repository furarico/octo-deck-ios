//
//  CardRepositoryError.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

enum CardRepositoryError: Error {
    case apiError(_ statusCode: Int)
}

//
//  StatisticRepositoryError.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

enum StatisticRepositoryError: Error {
    case apiError(_ statusCode: Int)
}

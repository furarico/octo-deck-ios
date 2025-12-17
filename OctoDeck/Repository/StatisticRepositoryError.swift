//
//  StatisticRepositoryError.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/17.
//

import Foundation

enum StatisticRepositoryError: Error {
    case apiError(_ statusCode: Int, _ payload: Any?)
}

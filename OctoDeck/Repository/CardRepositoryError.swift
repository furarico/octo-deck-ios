//
//  CardRepositoryError.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import Foundation

enum CardRepositoryError: Error {
    case apiError(_ statusCode: Int, _ payload: Any?)
}

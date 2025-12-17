//
//  APIClient.swift
//  OctoDeck
//
//  Created by Kanta Oikawa on 2025/12/16.
//

import OpenAPIRuntime
import OpenAPIURLSession

extension Client {
    static func build() async throws -> Client {
        return Client(
            serverURL: try Servers.Server3.url(),
            configuration: .init(dateTranscoder: .iso8601WithFractionalSeconds),
            transport: URLSessionTransport(),
            middlewares: [APIAuthMiddleware()]
        )
    }
}

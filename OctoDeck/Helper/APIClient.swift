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
            serverURL: try Servers.Server4.url(),
            configuration: .init(dateTranscoder: .iso8601),
            transport: URLSessionTransport(),
            middlewares: [APIAuthMiddleware()]
        )
    }
}

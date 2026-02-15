//
//  APIClient.swift
//  GoPaddi
//
//  Manages network requests and response handling for the application using URLSession.
//

import Foundation

/// A reusable, protocol-based API client for making HTTP requests.
protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    func requestVoid(_ endpoint: APIEndpoint) async throws
}

/// Describes an API endpoint with its path, method, and optional body.
struct APIEndpoint {
    let path: String
    let method: HTTPMethod
    let body: Encodable?
    let queryItems: [URLQueryItem]?

    init(
        path: String, method: HTTPMethod = .get, body: Encodable? = nil,
        queryItems: [URLQueryItem]? = nil
    ) {
        self.path = path
        self.method = method
        self.body = body
        self.queryItems = queryItems
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Concrete API client implementation using URLSession.
final class APIClient: APIClientProtocol {

    static let shared = APIClient()

    private let baseURL = "https://cab23b919476dcf5db46.free.beeceptor.com"
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(session: URLSession = .shared) {
        self.session = session

        self.decoder = JSONDecoder()

        self.encoder = JSONEncoder()
    }

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let request = try buildRequest(for: endpoint)

        let (data, response) = try await session.data(for: request)

        try validateResponse(response)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

    func requestVoid(_ endpoint: APIEndpoint) async throws {
        let request = try buildRequest(for: endpoint)

        let (_, response) = try await session.data(for: request)

        try validateResponse(response)
    }

    // MARK: - Private Helpers

    private func buildRequest(for endpoint: APIEndpoint) throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }

        if let queryItems = endpoint.queryItems {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30

        if let body = endpoint.body {
            request.httpBody = try encoder.encode(AnyEncodable(body))
        }

        return request
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
}

// MARK: - Type-erased Encodable wrapper

/// Wraps any Encodable value so it can be encoded generically.
private struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void

    init(_ wrapped: Encodable) {
        self.encodeClosure = { encoder in
            try wrapped.encode(to: encoder)
        }
    }

    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}

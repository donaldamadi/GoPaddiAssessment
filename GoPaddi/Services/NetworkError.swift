//
//  NetworkError.swift
//  GoPaddi
//
//  Standardized error types for network operations and data decoding.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case decodingError(Error)
    case serverError(statusCode: Int)
    case noData
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please try again."
        case .requestFailed(let error):
            return "Network request failed: \(error.localizedDescription)"
        case .decodingError:
            return "Failed to process server response."
        case .serverError(let code):
            return "Server error (code: \(code)). Please try again later."
        case .noData:
            return "No data received from server."
        case .unknown:
            return "An unexpected error occurred."
        }
    }
}

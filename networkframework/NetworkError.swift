//
//  Error.swift
//  networkframework
//
import Foundation

protocol NetworkError: Error, Sendable {
    var localizedDescription: String { get }
}

public enum APIServiceError: Error {
    case timeout
    case decode
    case badRequest
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown

    public var localizedDescription: String {
        switch self {
          case .timeout: return "Request timed out"
          case .decode: return "Decode Error"
          case .badRequest: return "Bad request"
          case .invalidURL: return "Invalid URL"
          case .noResponse: return "No Response"
          case .unauthorized: return "Unauthorized URL"
          case .unexpectedStatusCode: return "Status Code Error"
          case .unknown: return "Unknown Error"
        }
    }
}

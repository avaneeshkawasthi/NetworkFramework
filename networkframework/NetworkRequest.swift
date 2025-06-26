//
//  Networkable.swift
//  networkframework
//

import Foundation
import Combine

public protocol RequestProtocol {
    func sendRequest<T: Decodable>(endpoint: EndPoint) async throws -> T
    func sendRequest<T: Decodable>(endpoint: EndPoint, resultHandler: @escaping (Result<T, APIServiceError>) -> Void)
    func sendRequest<T: Decodable>(endpoint: EndPoint, type: T.Type) -> AnyPublisher<T, APIServiceError>
}

public extension RequestProtocol {
    func createRequest(endPoint: EndPoint) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        guard let url = urlComponents.url else {
            return nil
        }
        let encoder = JSONEncoder()
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.header
        if let body = endPoint.body {
            request.httpBody = try? encoder.encode(body)
        }
        return request
    }
}

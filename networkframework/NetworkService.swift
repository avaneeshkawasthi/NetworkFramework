//
//  NetworkService.swift
//  networkframework


import Foundation
import Combine

// MARK: - Public API for Framework

public final class NetworkService: RequestProtocol {
    
    public init() { }
    
    public func sendRequest<T>(urlStr: String) async throws -> T where T : Decodable {
        guard let urlStr = urlStr as String?, let url = URL(string: urlStr) as URL? else {
            throw APIServiceError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
            throw APIServiceError.unexpectedStatusCode
        }
        guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
            throw APIServiceError.decode
        }
        return decodedResponse
    }
    
    public func sendRequest<T>(endpoint: EndPoint, type: T.Type) -> AnyPublisher<T, APIServiceError> where T: Decodable {
        guard let urlRequest = createRequest(endPoint: endpoint) else {
            preconditionFailure("Failed URLRequest")
        }
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                    throw APIServiceError.invalidURL
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIServiceError in
                if error is DecodingError {
                    return APIServiceError.decode
                } else if let error = error as? APIServiceError {
                    return error
                } else {
                    return APIServiceError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func sendRequest<T: Decodable>(endpoint: EndPoint) async throws -> T {
        guard let urlRequest = createRequest(endPoint: endpoint) else {
            throw APIServiceError.decode
        }
        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
                .dataTask(with: urlRequest) { data, response, _ in
                    guard response is HTTPURLResponse else {
                        continuation.resume(throwing: APIServiceError.invalidURL)
                        return
                    }
                    guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                        continuation.resume(throwing: APIServiceError.unexpectedStatusCode)
                        return
                    }
                    guard let data = data else {
                        continuation.resume(throwing: APIServiceError.unknown)
                        return
                    }
                    guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                        continuation.resume(throwing: APIServiceError.decode)
                        return
                    }
                    continuation.resume(returning: decodedResponse)
                }
            task.resume()
        }
    }
    
    public func sendRequest<T: Decodable>(endpoint: EndPoint,
                                          resultHandler: @Sendable @escaping (Result<T, APIServiceError>) -> Void) {
        
        guard let urlRequest = createRequest(endPoint: endpoint) else {
            return
        }
        let urlTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                resultHandler(.failure(.invalidURL))
                return
            }
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                resultHandler(.failure(.unexpectedStatusCode))
                return
            }
            guard let data = data else {
                resultHandler(.failure(.unknown))
                return
            }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                resultHandler(.failure(.decode))
                return
            }
            resultHandler(.success(decodedResponse))
        }
        urlTask.resume()
    }
    
}

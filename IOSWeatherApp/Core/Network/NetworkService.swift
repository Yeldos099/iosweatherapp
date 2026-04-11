//
//  NetworkService.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 10.04.2026.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(url: URL) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    func request<T: Decodable>(url: URL) async throws -> T {
        
        do {
            let (data, response) = try await session.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299: break
                case 400...499:
                    throw NetworkError.clientError(statusCode: httpResponse.statusCode)
                case 500...599:
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                default: break
                }
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch let error as NSError {
            switch error.code {
            case NSURLErrorNotConnectedToInternet:
                throw NetworkError.noConnection
            case NSURLErrorTimedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.unknown(error)
            }
        }
    }
}

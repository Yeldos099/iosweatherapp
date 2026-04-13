//
//  NetworkError.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 10.04.2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case noConnection
    case timeout
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "Нет подключения к интернету"
        case .timeout:
            return "Превышено время ожидания"
        case .clientError(let code):
            return "Ошибка клиента: \(code)"
        case .serverError(let code):
            return "Ошибка сервера: \(code)"
        case .decodingError(let error):
            return "Ошибка декодирования: \(error.localizedDescription)"
        case .unknown(let error):
            return "Неизвестная ошибка: \(error.localizedDescription)"
        
        }
    }
}

//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Elchın on 10.08.26.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badBody
    case badData
    case badRequest
    case badParsing
    case notFound
    case unauthorized
    case serverError
    case custom(Error)
    
    var errorMessage: String {
        switch self {
        case .badURL:
            return "Bad Request"
        case .badBody:
            return "Missing body"
        case .badData:
            return "Missing data"
        case .badRequest:
            return "Bad Request"
        case .badParsing:
            return "Bad Parsing"
        case .notFound:
            return "Not found"
        case .unauthorized:
            return "Unauthorized"
        case .serverError:
            return "Server error"
        case .custom(let error):
            return error.localizedDescription
        }
    }
}

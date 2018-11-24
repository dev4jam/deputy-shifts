//
//  NetworkErrors.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation

/// Possible networking error
///
/// - dataIsNotEncodable: data cannot be encoded in format you have specified
/// - stringFailedToDecode: failed to decode data with given encoding
public enum NetworkError: Error {
    case dataIsNotEncodable(String)
    case stringFailedToDecode(String)
    case invalidURL(String)
    case notAuthorised(String)
    case authorisationExpired(String)
    case noResponse(String)
    case missingEndpoint(String)
    case failedToParseData(String)
    case missingData(String)
    case failedToDecode(String)
    case genericError(String)
    
    public var localizedDescription: String {
        return message
    }
    
    public var message: String {
        switch self {
        case .dataIsNotEncodable(let message),
             .stringFailedToDecode(let message),
             .invalidURL(let message),
             .notAuthorised(let message),
             .authorisationExpired(let message),
             .noResponse(let message),
             .missingEndpoint(let message),
             .failedToParseData(let message),
             .missingData(let message),
             .failedToDecode(let message),
             .genericError(let message):
            
            return message
        }
    }
}

//
//  PlainTextOperation.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 26/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import When

/// Model Operation, return a response as Decodable Model
open class PlainTextOperation: OperationProtocol {
    public typealias DataType = String?
    
    /// Request
    public var request: RequestProtocol?
    
    /// Init
    public init() { }
    
    /// Execute a request and return your specified model `Output`.
    ///
    /// - Parameters:
    ///   - service: service to use
    /// - Returns: Promise
    public func execute(in service: NetworkServiceProtocol) -> Promise<String?> {
        return service.execute(request)
            .then { response -> String? in
                guard let data = response.data else {
                    throw NetworkError.missingData("response with no data")
                }
                
                return String(data: data, encoding: .utf8)
            }
    }
}

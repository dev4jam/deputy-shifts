//
//  ModelOperation.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import When

/// Model Operation, return a response as Decodable Model
open class ModelOperation<Output: Decodable>: OperationProtocol {
    public typealias DataType = Output
    
    /// Request
    public var request: RequestProtocol?
    
    /// Init
    public init() {
    }
    
    /// Execute a request and return your specified model `Output`.
    ///
    /// - Parameters:
    ///   - service: service to use
    /// - Returns: Promise
    public func execute(in service: NetworkServiceProtocol) -> Promise<Output> {
        return service.execute(request)
            .then { response -> Output in
                guard let data = response.data else {
                    throw NetworkError.missingData("Response contains no data")
                }
                
                do {
                    let decoder: JSONDecoder = JSONDecoder()
                    
                    return try decoder.decode(Output.self, from: data)
                } catch let error {
                    throw NetworkError.failedToDecode(error.localizedDescription)
                }
            }
    }
}

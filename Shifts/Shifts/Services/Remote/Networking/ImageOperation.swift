//
//  ImageOperation.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import When

/// Model Operation, return a response as Decodable Model
open class ImageOperation: OperationProtocol {
    public typealias DataType = UIImage?
    
    /// Request
    public var request: RequestProtocol?
    
    /// Init
    public init() { }
    
    /// Execute a request and return your specified model `Output`.
    ///
    /// - Parameters:
    ///   - service: service to use
    /// - Returns: Promise
    public func execute(in service: NetworkServiceProtocol) -> Promise<UIImage?> {
        return service.execute(request)
            .then { response -> UIImage? in
                guard let data = response.data else {
                    throw NetworkError.missingData("response with no data")
                }
                
                return UIImage(data: data)
            }
    }
}

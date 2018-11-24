//
//  OperationProtocol.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import When

public protocol OperationProtocol {
    associatedtype T
    
    /// Request
    var request: RequestProtocol? { get set }
    
    /// Execute an operation into specified service
    ///
    /// - Parameters:
    ///   - service: service to use
    /// - Returns: Promise
    func execute(in service: NetworkServiceProtocol) -> Promise<T>
}

//
//  NetworkServiceProtocol.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import When

public enum SessionAuth {
    case token(String)
    case basic(String, String)
}

public protocol NetworkServiceProtocol: class {
    var headers: HeadersDict { get set }
    var auth: SessionAuth? { get set }
    var url: String { get }
    var cachePolicy: URLRequest.CachePolicy { get set }
    
    init(baseUrl: String, auth: SessionAuth?, headers: HeadersDict)
    
    func execute(_ request: RequestProtocol?) -> Promise<ResponseProtocol>
}

//
//  NetworkService.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import When

/// Service is a concrete implementation of the ServiceProtocol
open class NetworkService: NSObject, NetworkServiceProtocol {
    /// Session headers
    public var headers: HeadersDict
    
    /// URL session
    public let session: URLSession
    
    /// Authentication
    public var auth: SessionAuth?
    
    /// Base url
    public var url: String
    
    /// Service cache policy
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

    /// Internal processing queue
    private let networkingQueue = DispatchQueue(label: "network-processing-queue")

    /// Initialize a new service with given parameters
    public required init(baseUrl: String, auth: SessionAuth?, headers: HeadersDict) {
        self.url     = baseUrl
        self.auth    = auth
        self.headers = headers
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    /// Execute a request and return a promise with the response
    ///
    /// - Parameters:
    ///   - request: request to execute
    /// - Returns: Promise
    /// - Throws: throw an exception if operation cannot be executed
    public func execute(_ request: RequestProtocol?) -> Promise<ResponseProtocol> {
        // Wrap in a promise the request itself
        let promise = Promise<ResponseProtocol>()
        
        networkingQueue.async {
            guard let rq = request else { // missing request
                // yield this thread
                promise.reject(NetworkError.missingEndpoint("no request specified"))
                return
            }
            
            do {
                let urlRequest = try rq.urlRequest(in: self)
                
                let task: URLSessionDataTask = self.session.dataTask(with: urlRequest) { data, response, error in
                    let parsedResponse = Response(urlResponse: response, data: data, request: rq)
                    
                    if let url = urlRequest.url,
                        let responseStr = parsedResponse.toString() {
                        
                        #if DEBUG
                        print("Response from \(url):")
                        print(responseStr)
                        #endif
                    }
                    
                    switch parsedResponse.type {
                    case .success: // success
                        promise.resolve(parsedResponse)
                    case .error(let code): // failure
                        if code == 23 {
                            promise.reject(NetworkError.authorisationExpired("session expired"))
                        } else if code == 401 {
                            promise.reject(NetworkError.notAuthorised("request is not authorized"))
                        } else if parsedResponse.data != nil {
                            promise.resolve(parsedResponse)
                        } else {
                            promise.reject(NetworkError.genericError("received error code: \(code)"))
                        }
                    case .noResponse:  // no response
                        promise.reject(NetworkError.noResponse("no response from server"))
                    }
                }
                
                task.resume()
            } catch (let error) {
                #if DEBUG
                print(error.localizedDescription)
                #endif

                promise.reject(error)
            }
        }
        
        return promise
    }
}

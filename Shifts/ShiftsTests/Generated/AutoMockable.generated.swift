// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import RIBs
import RxSwift
import CoreLocation
import When

@testable import Shifts













final class LocationServiceProtocolMock: LocationServiceProtocol {
    var lastLocation: CLLocation?

    //MARK: - discover

    var discoverCallsCount = 0
    var discoverCalled: Bool {
        return discoverCallsCount > 0
    }
    var discoverReturnValue: Promise<CLLocation>!
    var discoverHandler: (() -> Promise<CLLocation>)?

    func discover() -> Promise<CLLocation> {
        discoverCallsCount += 1
        return discoverHandler.map({ $0() }) ?? discoverReturnValue
    }

}

final class NetworkServiceProtocolMock: NetworkServiceProtocol {
    var headers: HeadersDict = [:]
    var auth: SessionAuth?
    var url: String {
        get { return underlyingUrl }
        set(value) { underlyingUrl = value }
    }
    var underlyingUrl: String!
    var cachePolicy: URLRequest.CachePolicy {
        get { return underlyingCachePolicy }
        set(value) { underlyingCachePolicy = value }
    }
    var underlyingCachePolicy: URLRequest.CachePolicy!

    //MARK: - init

    var initBaseUrlAuthHeadersReceivedArguments: (baseUrl: String, auth: SessionAuth?, headers: HeadersDict)?
    var initBaseUrlAuthHeadersHandler: ((String, SessionAuth?, HeadersDict) -> Void)?

    required init(baseUrl: String, auth: SessionAuth?, headers: HeadersDict) {
        initBaseUrlAuthHeadersReceivedArguments = (baseUrl: baseUrl, auth: auth, headers: headers)
        initBaseUrlAuthHeadersHandler?(baseUrl, auth, headers)
    }
    //MARK: - execute

    var executeCallsCount = 0
    var executeCalled: Bool {
        return executeCallsCount > 0
    }
    var executeReceivedRequest: RequestProtocol?
    var executeReturnValue: Promise<ResponseProtocol>!
    var executeHandler: ((RequestProtocol?) -> Promise<ResponseProtocol>)?

    func execute(_ request: RequestProtocol?) -> Promise<ResponseProtocol> {
        executeCallsCount += 1
        executeReceivedRequest = request
        return executeHandler.map({ $0(request) }) ?? executeReturnValue
    }

}


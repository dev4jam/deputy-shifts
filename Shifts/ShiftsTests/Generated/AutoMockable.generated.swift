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

final class ShiftsServiceProtocolMock: ShiftsServiceProtocol {

    //MARK: - init

    var initNetworkServiceImageServiceReceivedArguments: (networkService: NetworkServiceProtocol, imageService: NetworkServiceProtocol)?
    var initNetworkServiceImageServiceHandler: ((NetworkServiceProtocol, NetworkServiceProtocol) -> Void)?

    required init(networkService: NetworkServiceProtocol, imageService: NetworkServiceProtocol) {
        initNetworkServiceImageServiceReceivedArguments = (networkService: networkService, imageService: imageService)
        initNetworkServiceImageServiceHandler?(networkService, imageService)
    }
    //MARK: - getShifts

    var getShiftsCallsCount = 0
    var getShiftsCalled: Bool {
        return getShiftsCallsCount > 0
    }
    var getShiftsReturnValue: Promise<[Shift]>!
    var getShiftsHandler: (() -> Promise<[Shift]>)?

    func getShifts() -> Promise<[Shift]> {
        getShiftsCallsCount += 1
        return getShiftsHandler.map({ $0() }) ?? getShiftsReturnValue
    }

    //MARK: - startShift

    var startShiftLatitudeLongitudeCallsCount = 0
    var startShiftLatitudeLongitudeCalled: Bool {
        return startShiftLatitudeLongitudeCallsCount > 0
    }
    var startShiftLatitudeLongitudeReceivedArguments: (latitude: Double, longitude: Double)?
    var startShiftLatitudeLongitudeReturnValue: Promise<Bool>!
    var startShiftLatitudeLongitudeHandler: ((Double, Double) -> Promise<Bool>)?

    func startShift(latitude: Double, longitude: Double) -> Promise<Bool> {
        startShiftLatitudeLongitudeCallsCount += 1
        startShiftLatitudeLongitudeReceivedArguments = (latitude: latitude, longitude: longitude)
        return startShiftLatitudeLongitudeHandler.map({ $0(latitude, longitude) }) ?? startShiftLatitudeLongitudeReturnValue
    }

    //MARK: - stopShift

    var stopShiftLatitudeLongitudeCallsCount = 0
    var stopShiftLatitudeLongitudeCalled: Bool {
        return stopShiftLatitudeLongitudeCallsCount > 0
    }
    var stopShiftLatitudeLongitudeReceivedArguments: (latitude: Double, longitude: Double)?
    var stopShiftLatitudeLongitudeReturnValue: Promise<Bool>!
    var stopShiftLatitudeLongitudeHandler: ((Double, Double) -> Promise<Bool>)?

    func stopShift(latitude: Double, longitude: Double) -> Promise<Bool> {
        stopShiftLatitudeLongitudeCallsCount += 1
        stopShiftLatitudeLongitudeReceivedArguments = (latitude: latitude, longitude: longitude)
        return stopShiftLatitudeLongitudeHandler.map({ $0(latitude, longitude) }) ?? stopShiftLatitudeLongitudeReturnValue
    }

    //MARK: - getShiftImage

    var getShiftImageUrlCallsCount = 0
    var getShiftImageUrlCalled: Bool {
        return getShiftImageUrlCallsCount > 0
    }
    var getShiftImageUrlReceivedUrl: String?
    var getShiftImageUrlReturnValue: Promise<UIImage>!
    var getShiftImageUrlHandler: ((String) -> Promise<UIImage>)?

    func getShiftImage(url: String) -> Promise<UIImage> {
        getShiftImageUrlCallsCount += 1
        getShiftImageUrlReceivedUrl = url
        return getShiftImageUrlHandler.map({ $0(url) }) ?? getShiftImageUrlReturnValue
    }

}


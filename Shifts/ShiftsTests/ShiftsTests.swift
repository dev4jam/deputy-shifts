//
//  ShiftsTests.swift
//  ShiftsTests
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import XCTest
import RxSwift
import When
import CoreLocation

@testable import Shifts

final class ShiftsTests: XCTestCase {
    private var interactor: ShiftsInteractor!
    private var router: ShiftsRoutingMock!
    private var view: ShiftsViewControllableMock!
    private var presenter: ShiftsPresentableMock!
    private var appState: Variable<AppState>!
    private var locationService: LocationServiceProtocolMock!
    private var networkService: NetworkServiceProtocolMock!
    private var imageService: NetworkServiceProtocolMock!
    private var locationPromise: Promise<CLLocation>!
    private var responsePromise: Promise<ResponseProtocol>!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        locationPromise = Promise<CLLocation>()
        responsePromise = Promise<ResponseProtocol>()
        locationService = LocationServiceProtocolMock()
        imageService    = NetworkServiceProtocolMock(baseUrl: "", auth: nil, headers: [:])
        networkService  = NetworkServiceProtocolMock(baseUrl: Config.serviceBaseUrl,
                                                     auth: .token(Config.serviceAccessToken),
                                                     headers: [:])
        appState   = Variable<AppState>(.launched)
        presenter  = ShiftsPresentableMock()
        view       = ShiftsViewControllableMock()
        interactor = ShiftsInteractor(presenter: presenter,
                                      networkService: networkService,
                                      imageService: imageService,
                                      locationService: locationService,
                                      state: appState)
        
        router = ShiftsRoutingMock(interactable: interactor, viewController: view)
        
        interactor.router = router
        
        locationService.discoverReturnValue = locationPromise
        networkService.executeReturnValue   = responsePromise
        imageService.executeReturnValue     = responsePromise
        
        locationService.lastLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Tests
    
    func testLifecycle() {
        // This is an example of an interactor test case.
        // Test your interactor binds observables and sends messages to router or listener.
        XCTAssertFalse(interactor.isActive)
        XCTAssertEqual(router.children.count, 0)
        
        interactor.activate()
        
        XCTAssertTrue(interactor.isActive)
        
        interactor.deactivate()
        
        XCTAssertFalse(interactor.isActive)
    }
    
    func testInitialState() {
        XCTAssertEqual(presenter.updateActionTitleToCallsCount, 0)
        XCTAssertEqual(presenter.showShiftsCallsCount, 0)
        XCTAssertEqual(presenter.showActionCallsCount, 0)
        XCTAssertEqual(presenter.hideActionCallsCount, 0)
        XCTAssertEqual(presenter.showLoadingWithCallsCount, 0)
        XCTAssertEqual(presenter.showErrorWithCallsCount, 0)
        XCTAssertEqual(presenter.hideLoadingCallsCount, 0)
        
        interactor.activate()
        interactor.didPrepareView()

        XCTAssertEqual(presenter.updateActionTitleToCallsCount, 1)
        XCTAssertEqual(presenter.updateActionTitleToReceivedNewTitle, L10n.start)
        
        interactor.deactivate()
    }

    func testInitialLoading() {
        interactor.activate()
        interactor.didPrepareView()
        
        locationPromise.resolve(CLLocation(latitude: 1.0, longitude: 1.0))
        responsePromise.resolve(<#T##value: ResponseProtocol##ResponseProtocol#>)
        
        interactor.deactivate()
    }
}

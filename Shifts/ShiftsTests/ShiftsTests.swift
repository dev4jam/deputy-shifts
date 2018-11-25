//
//  ShiftsTests.swift
//  ShiftsTests
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import XCTest
import RxSwift

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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        locationService = LocationServiceProtocolMock()
        networkService = NetworkServiceProtocolMock(baseUrl: "", auth: nil, headers: [:])
        imageService = NetworkServiceProtocolMock(baseUrl: "", auth: nil, headers: [:])
        
        appState   = Variable<AppState>(.active)
        presenter  = ShiftsPresentableMock()
        view       = ShiftsViewControllableMock()
        interactor = ShiftsInteractor(presenter: presenter,
                                      networkService: networkService,
                                      imageService: imageService,
                                      locationService: locationService,
                                      state: appState)
        
        router = ShiftsRoutingMock(interactable: interactor, viewController: view)
        
        interactor.router = router
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
}

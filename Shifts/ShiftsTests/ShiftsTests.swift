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
    private var service: ShiftsServiceProtocolMock!
    private var locationPromise: Promise<CLLocation>!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        locationPromise = Promise<CLLocation>()
        locationService = LocationServiceProtocolMock()
        
        locationService.discoverReturnValue = locationPromise
        locationService.lastLocation = CLLocation(latitude: 0.0, longitude: 0.0)

        let netService  = NetworkServiceProtocolMock(baseUrl: Config.serviceBaseUrl,
                                                     auth: .token(Config.serviceAccessToken),
                                                     headers: [:])
        let imgService  = NetworkServiceProtocolMock(baseUrl: "", auth: nil, headers: [:])
        
        service    = ShiftsServiceProtocolMock(networkService: netService, imageService: imgService)
        appState   = Variable<AppState>(.launched)
        presenter  = ShiftsPresentableMock()
        view       = ShiftsViewControllableMock()
        interactor = ShiftsInteractor(presenter: presenter,
                                      service: service,
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
        service.getShiftsReturnValue = Promise<[Shift]>()

        XCTAssertFalse(interactor.isActive)
        XCTAssertEqual(router.children.count, 0)
        
        interactor.activate()
        
        XCTAssertTrue(interactor.isActive)
        
        interactor.deactivate()
        
        XCTAssertFalse(interactor.isActive)
    }
    
    func testInitialState() {
        service.getShiftsReturnValue = Promise<[Shift]>()
        
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
        let expect = expectation(description: "Service result callback")
        
        service.getShiftsHandler = { () -> Promise<[Shift]> in
            let promise = Promise<[Shift]>()
            
            DispatchQueue.main.async {
                promise.resolve([])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    expect.fulfill()
                }
            }
            
            return promise
        }
        
        interactor.activate()
        interactor.didPrepareView()
        
        locationPromise.resolve(CLLocation(latitude: 1.0, longitude: 1.0))
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertEqual(self.presenter.showLoadingWithCallsCount, 1)
            XCTAssertEqual(self.presenter.hideLoadingCallsCount, 1)

            XCTAssertEqual(self.presenter.updateActionTitleToCallsCount, 2)
            XCTAssertEqual(self.presenter.updateActionTitleToReceivedNewTitle, L10n.start)
            
            XCTAssertEqual(self.presenter.showActionCallsCount, 1)
            XCTAssertEqual(self.presenter.showShiftsCallsCount, 0)
            XCTAssertEqual(self.presenter.hideActionCallsCount, 0)

            self.interactor.deactivate()
        }
    }
    
    func testFailedLoading() {
        let expect = expectation(description: "Service result callback")
        
        service.getShiftsHandler = { () -> Promise<[Shift]> in
            let promise = Promise<[Shift]>()
            
            DispatchQueue.main.async {
                promise.reject(NetworkError.genericError("Test"))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    expect.fulfill()
                }
            }
            
            return promise
        }
        
        interactor.activate()
        interactor.didPrepareView()
        
        locationPromise.resolve(CLLocation(latitude: 1.0, longitude: 1.0))
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertEqual(self.presenter.showLoadingWithCallsCount, 1)
            XCTAssertEqual(self.presenter.hideLoadingCallsCount, 0)
            
            XCTAssertEqual(self.presenter.updateActionTitleToCallsCount, 1)
            XCTAssertEqual(self.presenter.updateActionTitleToReceivedNewTitle, L10n.start)
            
            XCTAssertEqual(self.presenter.showActionCallsCount, 0)
            XCTAssertEqual(self.presenter.showShiftsCallsCount, 0)
            XCTAssertEqual(self.presenter.hideActionCallsCount, 0)
            
            XCTAssertEqual(self.presenter.showErrorWithCallsCount, 1)
            XCTAssertEqual(self.presenter.showErrorWithReceivedStatus, "Test")

            self.interactor.deactivate()
        }
    }

    func testShowStartedShift() {
        let expect = expectation(description: "Service result callback")
        
        service.getShiftsHandler = { () -> Promise<[Shift]> in
            let promise = Promise<[Shift]>()
            
            DispatchQueue.main.async {
                promise.resolve([
                    Shift(id: 1,
                          start: "2018-01-01T00:11:00+00:00",
                          end: "2018-01-01T02:11:00+00:00",
                          startLatitude: "1.0",
                          startLongitude: "1.0",
                          endLatitude: "2.0",
                          endLongitude: "2.0",
                          image: "www.google.com"),
                    Shift(id: 0,
                          start: "2018-01-01T00:11:00+00:00",
                          end: "",
                          startLatitude: "2.0",
                          startLongitude: "2.0",
                          endLatitude: "2.0",
                          endLongitude: "2.0",
                          image: "www.google.com")
                ])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    expect.fulfill()
                }
            }
            
            return promise
        }
        
        interactor.activate()
        interactor.didPrepareView()
        
        locationPromise.resolve(CLLocation(latitude: 1.0, longitude: 1.0))
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertEqual(self.presenter.showLoadingWithCallsCount, 1)
            XCTAssertEqual(self.presenter.hideLoadingCallsCount, 1)
            
            XCTAssertEqual(self.presenter.updateActionTitleToCallsCount, 2)
            XCTAssertEqual(self.presenter.updateActionTitleToReceivedNewTitle, L10n.stop)
            
            XCTAssertEqual(self.presenter.showShiftsCallsCount, 1)
            XCTAssertNotNil(self.presenter.showShiftsReceivedShifts)
            XCTAssertEqual(self.presenter.showShiftsReceivedShifts!.count, 2)
            
            XCTAssertEqual(self.presenter.showActionCallsCount, 1)
            XCTAssertEqual(self.presenter.hideActionCallsCount, 0)
            
            XCTAssertEqual(self.presenter.showErrorWithCallsCount, 0)

            self.interactor.deactivate()
        }
    }

    func testShowStoppedShift() {
        let expect = expectation(description: "Service result callback")
        
        service.getShiftsHandler = { () -> Promise<[Shift]> in
            let promise = Promise<[Shift]>()
            
            DispatchQueue.main.async {
                promise.resolve([
                    Shift(id: 1,
                          start: "2018-01-01T00:11:00+00:00",
                          end: "2018-01-01T02:11:00+00:00",
                          startLatitude: "1.0",
                          startLongitude: "1.0",
                          endLatitude: "2.0",
                          endLongitude: "2.0",
                          image: "www.google.com"),
                    Shift(id: 0,
                          start: "2018-01-01T00:11:00+00:00",
                          end: "2018-01-01T02:11:00+00:00",
                          startLatitude: "2.0",
                          startLongitude: "2.0",
                          endLatitude: "2.0",
                          endLongitude: "2.0",
                          image: "www.google.com")
                    ])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    expect.fulfill()
                }
            }
            
            return promise
        }
        
        interactor.activate()
        interactor.didPrepareView()
        
        locationPromise.resolve(CLLocation(latitude: 1.0, longitude: 1.0))
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertEqual(self.presenter.showLoadingWithCallsCount, 1)
            XCTAssertEqual(self.presenter.hideLoadingCallsCount, 1)
            
            XCTAssertEqual(self.presenter.updateActionTitleToCallsCount, 2)
            XCTAssertEqual(self.presenter.updateActionTitleToReceivedNewTitle, L10n.start)
            
            XCTAssertEqual(self.presenter.showShiftsCallsCount, 1)
            XCTAssertNotNil(self.presenter.showShiftsReceivedShifts)
            XCTAssertEqual(self.presenter.showShiftsReceivedShifts!.count, 2)
            
            XCTAssertEqual(self.presenter.showActionCallsCount, 1)
            XCTAssertEqual(self.presenter.hideActionCallsCount, 0)
            
            XCTAssertEqual(self.presenter.showErrorWithCallsCount, 0)
            
            self.interactor.deactivate()
        }
    }
    
    func testFailedLocation() {
        let expect = expectation(description: "Service result callback")
        
        service.startShiftLatitudeLongitudeHandler = { (latitude, longitude) -> Promise<Bool> in
            let promise = Promise<Bool>()
            
            DispatchQueue.main.async {
                promise.resolve(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    expect.fulfill()
                }
            }
            
            return promise
        }
        
        service.getShiftsHandler = { () -> Promise<[Shift]> in
            let promise = Promise<[Shift]>()
            
            DispatchQueue.main.async {
                promise.resolve([
                    Shift(id: 0,
                          start: "2018-01-01T00:11:00+00:00",
                          end: "2018-01-01T02:11:00+00:00",
                          startLatitude: "2.0",
                          startLongitude: "2.0",
                          endLatitude: "2.0",
                          endLongitude: "2.0",
                          image: "www.google.com")
                    ])
            }
            
            return promise
        }
        
        interactor.activate()
        interactor.didPrepareView()
        
        DispatchQueue.main.async {
            self.interactor.didSelectAction()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                expect.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }

            XCTAssertEqual(self.presenter.showLoadingWithCallsCount, 1)
            XCTAssertEqual(self.presenter.hideLoadingCallsCount, 1)
            
            XCTAssertEqual(self.presenter.updateActionTitleToCallsCount, 4)
            XCTAssertEqual(self.presenter.updateActionTitleToReceivedNewTitle, L10n.start)
            
            XCTAssertEqual(self.presenter.showShiftsCallsCount, 1)
            XCTAssertNotNil(self.presenter.showShiftsReceivedShifts)
            XCTAssertEqual(self.presenter.showShiftsReceivedShifts!.count, 1)
            
            XCTAssertEqual(self.presenter.showActionCallsCount, 1)
            XCTAssertEqual(self.presenter.hideActionCallsCount, 1)
            
            XCTAssertEqual(self.presenter.showErrorWithCallsCount, 1)
            
            self.interactor.deactivate()
        }
    }


    func testStartShift() {
        let expect = expectation(description: "Service result callback")
        
        service.startShiftLatitudeLongitudeHandler = { (latitude, longitude) -> Promise<Bool> in
            let promise = Promise<Bool>()
            
            DispatchQueue.main.async {
                promise.resolve(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    expect.fulfill()
                }
            }
            
            return promise
        }
        
        service.getShiftsHandler = { () -> Promise<[Shift]> in
            let promise = Promise<[Shift]>()
            
            DispatchQueue.main.async {
                promise.resolve([
                    Shift(id: 0,
                          start: "2018-01-01T00:11:00+00:00",
                          end: "2018-01-01T02:11:00+00:00",
                          startLatitude: "2.0",
                          startLongitude: "2.0",
                          endLatitude: "2.0",
                          endLongitude: "2.0",
                          image: "www.google.com")
                    ])
            }
            
            return promise
        }
        
        interactor.activate()
        interactor.didPrepareView()
        
        locationPromise.resolve(CLLocation(latitude: 1.0, longitude: 1.0))
        
        DispatchQueue.main.async {
            self.interactor.didSelectAction()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertEqual(self.presenter.showLoadingWithCallsCount, 3)
            XCTAssertEqual(self.presenter.hideLoadingCallsCount, 2)
            
            XCTAssertEqual(self.presenter.updateActionTitleToCallsCount, 4)
            XCTAssertEqual(self.presenter.updateActionTitleToReceivedNewTitle, L10n.start)
            
            XCTAssertEqual(self.presenter.showShiftsCallsCount, 2)
            XCTAssertNotNil(self.presenter.showShiftsReceivedShifts)
            XCTAssertEqual(self.presenter.showShiftsReceivedShifts!.count, 1)
            
            XCTAssertEqual(self.presenter.showActionCallsCount, 2)
            XCTAssertEqual(self.presenter.hideActionCallsCount, 1)
            
            XCTAssertEqual(self.presenter.showErrorWithCallsCount, 0)
            
            self.interactor.deactivate()
        }
    }
    
    func testFailedStartShift() {
        let expect = expectation(description: "Service result callback")
        
        service.startShiftLatitudeLongitudeHandler = { (latitude, longitude) -> Promise<Bool> in
            let promise = Promise<Bool>()
            
            DispatchQueue.main.async {
                promise.reject(NetworkError.genericError("Test"))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    expect.fulfill()
                }
            }
            
            return promise
        }
        
        service.getShiftsHandler = { () -> Promise<[Shift]> in
            let promise = Promise<[Shift]>()
            
            DispatchQueue.main.async {
                promise.resolve([
                    Shift(id: 0,
                          start: "2018-01-01T00:11:00+00:00",
                          end: "2018-01-01T02:11:00+00:00",
                          startLatitude: "2.0",
                          startLongitude: "2.0",
                          endLatitude: "2.0",
                          endLongitude: "2.0",
                          image: "www.google.com")
                    ])
            }
            
            return promise
        }
        
        interactor.activate()
        interactor.didPrepareView()
        
        locationPromise.resolve(CLLocation(latitude: 1.0, longitude: 1.0))
        
        DispatchQueue.main.async {
            self.interactor.didSelectAction()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertEqual(self.presenter.showLoadingWithCallsCount, 2)
            XCTAssertEqual(self.presenter.hideLoadingCallsCount, 1)
            
            XCTAssertEqual(self.presenter.updateActionTitleToCallsCount, 3)
            XCTAssertEqual(self.presenter.updateActionTitleToReceivedNewTitle, L10n.start)
            
            XCTAssertEqual(self.presenter.showShiftsCallsCount, 1)
            XCTAssertNotNil(self.presenter.showShiftsReceivedShifts)
            XCTAssertEqual(self.presenter.showShiftsReceivedShifts!.count, 1)
            
            XCTAssertEqual(self.presenter.showActionCallsCount, 1)
            XCTAssertEqual(self.presenter.hideActionCallsCount, 1)
            
            XCTAssertEqual(self.presenter.showErrorWithCallsCount, 1)
            
            self.interactor.deactivate()
        }
    }


    func testStopShift() {
        let expect = expectation(description: "Service result callback")
        
        service.stopShiftLatitudeLongitudeHandler = { (latitude, longitude) -> Promise<Bool> in
            let promise = Promise<Bool>()
            
            DispatchQueue.main.async {
                promise.resolve(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    expect.fulfill()
                }
            }
            
            return promise
        }
        
        service.getShiftsHandler = { () -> Promise<[Shift]> in
            let promise = Promise<[Shift]>()
            
            DispatchQueue.main.async {
                promise.resolve([
                    Shift(id: 0,
                          start: "2018-01-01T00:11:00+00:00",
                          end: "",
                          startLatitude: "2.0",
                          startLongitude: "2.0",
                          endLatitude: "2.0",
                          endLongitude: "2.0",
                          image: "www.google.com")
                    ])
            }
            
            return promise
        }
        
        interactor.activate()
        interactor.didPrepareView()
        
        locationPromise.resolve(CLLocation(latitude: 1.0, longitude: 1.0))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.interactor.didSelectAction()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertEqual(self.presenter.showLoadingWithCallsCount, 3)
            XCTAssertEqual(self.presenter.hideLoadingCallsCount, 2)
            
            XCTAssertEqual(self.presenter.updateActionTitleToCallsCount, 4)
            XCTAssertEqual(self.presenter.updateActionTitleToReceivedNewTitle, L10n.stop)
            
            XCTAssertEqual(self.presenter.showShiftsCallsCount, 2)
            XCTAssertNotNil(self.presenter.showShiftsReceivedShifts)
            XCTAssertEqual(self.presenter.showShiftsReceivedShifts!.count, 1)
            
            XCTAssertEqual(self.presenter.showActionCallsCount, 2)
            XCTAssertEqual(self.presenter.hideActionCallsCount, 1)
            
            XCTAssertEqual(self.presenter.showErrorWithCallsCount, 0)
            
            self.interactor.deactivate()
        }
    }

    func testFailedStopShift() {
        let expect = expectation(description: "Service result callback")
        
        service.stopShiftLatitudeLongitudeHandler = { (latitude, longitude) -> Promise<Bool> in
            let promise = Promise<Bool>()
            
            DispatchQueue.main.async {
                promise.reject(NetworkError.genericError("Test"))

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    expect.fulfill()
                }
            }
            
            return promise
        }
        
        service.getShiftsHandler = { () -> Promise<[Shift]> in
            let promise = Promise<[Shift]>()
            
            DispatchQueue.main.async {
                promise.resolve([
                    Shift(id: 0,
                          start: "2018-01-01T00:11:00+00:00",
                          end: "",
                          startLatitude: "2.0",
                          startLongitude: "2.0",
                          endLatitude: "2.0",
                          endLongitude: "2.0",
                          image: "www.google.com")
                    ])
            }
            
            return promise
        }
        
        interactor.activate()
        interactor.didPrepareView()
        
        locationPromise.resolve(CLLocation(latitude: 1.0, longitude: 1.0))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.interactor.didSelectAction()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertEqual(self.presenter.showLoadingWithCallsCount, 2)
            XCTAssertEqual(self.presenter.hideLoadingCallsCount, 1)
            
            XCTAssertEqual(self.presenter.updateActionTitleToCallsCount, 3)
            XCTAssertEqual(self.presenter.updateActionTitleToReceivedNewTitle, L10n.start)
            
            XCTAssertEqual(self.presenter.showShiftsCallsCount, 1)
            XCTAssertNotNil(self.presenter.showShiftsReceivedShifts)
            XCTAssertEqual(self.presenter.showShiftsReceivedShifts!.count, 1)
            
            XCTAssertEqual(self.presenter.showActionCallsCount, 1)
            XCTAssertEqual(self.presenter.hideActionCallsCount, 1)
            
            XCTAssertEqual(self.presenter.showErrorWithCallsCount, 1)
            
            self.interactor.deactivate()
        }
    }
}

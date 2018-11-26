//
//  ShiftsBuilder.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import RIBs
import RxSwift

protocol ShiftsDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    
    var networkService: NetworkServiceProtocol { get }
    var imageService: NetworkServiceProtocol { get }
    var state: Variable<AppState> { get }
}

final class ShiftsComponent: Component<ShiftsDependency> {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    
    let locationService: LocationServiceProtocol
    
    var networkService: NetworkServiceProtocol {
        return dependency.networkService
    }
    
    var imageService: NetworkServiceProtocol {
        return dependency.imageService
    }
    
    var state: Variable<AppState> {
        return dependency.state
    }
    
    init(dependency: ShiftsDependency, locationService: LocationServiceProtocol) {
        self.locationService = locationService
        
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol ShiftsBuildable: Buildable {
    func build(withListener listener: ShiftsListener) -> ShiftsRouting
}

final class ShiftsBuilder: Builder<ShiftsDependency>, ShiftsBuildable {

    override init(dependency: ShiftsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ShiftsListener) -> ShiftsRouting {
        let locationService = LocationService()
        let component       = ShiftsComponent(dependency: dependency,
                                              locationService: locationService)
        let service         = ShiftsService(networkService: component.networkService,
                                            imageService: component.imageService)
        let viewController  = ShiftsViewController()
        let interactor      = ShiftsInteractor(presenter: viewController,
                                               service: service,
                                               locationService: component.locationService,
                                               state: component.state)
        interactor.listener = listener
        
        return ShiftsRouter(interactor: interactor, viewController: viewController)
    }
}

//
//  ShiftsBuilder.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import RIBs

protocol ShiftsDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    
    var networkService: NetworkServiceProtocol { get }
    var imageService: NetworkServiceProtocol { get }
}

final class ShiftsComponent: Component<ShiftsDependency> {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    
    var networkService: NetworkServiceProtocol {
        return dependency.networkService
    }
    
    var imageService: NetworkServiceProtocol {
        return dependency.imageService
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
        let component      = ShiftsComponent(dependency: dependency)
        let viewController = ShiftsViewController()
        let interactor     = ShiftsInteractor(presenter: viewController,
                                              networkService: component.networkService,
                                              imageService: component.imageService)
        interactor.listener = listener
        
        return ShiftsRouter(interactor: interactor, viewController: viewController)
    }
}

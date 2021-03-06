//
//  RootBuilder.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import RIBs
import RxSwift

protocol RootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    
    var networkService: NetworkServiceProtocol { get }
    var imageService: NetworkServiceProtocol { get }
    var state: Variable<AppState> { get }
}

final class RootComponent: Component<RootDependency> {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    
    var networkService: NetworkServiceProtocol {
        return dependency.networkService
    }
    
    var imageService: NetworkServiceProtocol {
        return dependency.imageService
    }
    
    var state: Variable<AppState> {
        return dependency.state
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let component      = RootComponent(dependency: dependency)
        let viewController = RootViewController()
        let interactor     = RootInteractor(presenter: viewController)
        
        
        let shiftsBuilder = ShiftsBuilder(dependency: component)
        
        return RootRouter(interactor: interactor,
                          viewController: viewController,
                          shiftsBuilder: shiftsBuilder)
    }
}

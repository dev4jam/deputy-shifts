//
//  RootBuilder.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import RIBs

protocol RootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    
    var networkService: NetworkServiceProtocol { get }
    var imageService: NetworkServiceProtocol { get }
}

final class RootComponent: Component<RootDependency> {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    
    var networkService: NetworkServiceProtocol {
        return dependency.networkService
    }
    
    var imageService: NetworkServiceProtocol {
        return dependency.imageService
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
                
        return RootRouter(interactor: interactor,
                          viewController: viewController)
    }
}

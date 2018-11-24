//
//  RootRouter.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, ShiftsListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func presentInitialView(_ view: ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    private let shiftsBuilder: ShiftsBuildable
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         shiftsBuilder: ShiftsBuildable) {
        
        self.shiftsBuilder = shiftsBuilder
        
        super.init(interactor: interactor, viewController: viewController)
    
        interactor.router = self
    }
    
    // MARK: - RootRouting
    
    func routeToShifts() {
        let rib = shiftsBuilder.build(withListener: interactor)
        
        attachChild(rib)
        
        viewController.presentInitialView(rib.viewControllable)
    }
}

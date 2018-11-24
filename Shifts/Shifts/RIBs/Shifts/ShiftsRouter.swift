//
//  ShiftsRouter.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import RIBs

protocol ShiftsInteractable: Interactable {
    var router: ShiftsRouting? { get set }
    var listener: ShiftsListener? { get set }
}

protocol ShiftsViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ShiftsRouter: ViewableRouter<ShiftsInteractable, ShiftsViewControllable>, ShiftsRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ShiftsInteractable, viewController: ShiftsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}

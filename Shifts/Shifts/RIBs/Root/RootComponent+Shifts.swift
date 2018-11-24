//
//  RootComponent+Shifts.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the Shifts scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol RootDependencyShifts: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the Shifts scope.
}

extension RootComponent: ShiftsDependency {

    // TODO: Implement properties to provide for Shifts scope.
}

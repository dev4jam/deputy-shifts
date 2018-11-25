//
//  ShiftsMocks.swift
//  ShiftsTests
//
//  Created by Dmitry Klimkin on 26/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation

@testable import Shifts

final class ShiftsViewControllableMock: ShiftsViewControllable {
    // Variables
    var uiviewController: UIViewController = UIViewController() { didSet { uiviewControllerSetCallCount += 1 } }
    var uiviewControllerSetCallCount = 0
}

//
//  ShiftsViewController.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ShiftsPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ShiftsViewController: UIViewController, ShiftsPresentable, ShiftsViewControllable {

    weak var listener: ShiftsPresentableListener?
}

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
    func didPrepareView()
    func didSelectAction()
}

final class ShiftsViewController: UIViewController, ShiftsPresentable, ShiftsViewControllable {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var actionButton: UIButton!
    
    weak var listener: ShiftsPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listener?.didPrepareView()
    }
    
    // MARK: - ShiftsPresentable
    
    func showShifts(_ shifts: [ShiftVM]) {
        
    }
}

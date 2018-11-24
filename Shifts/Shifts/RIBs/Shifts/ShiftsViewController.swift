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
    
    private var shifts: [ShiftVM] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionButton.layer.cornerRadius = actionButton.frame.width / 2.0
        actionButton.layer.borderColor  = UIColor.red.cgColor
        actionButton.layer.borderWidth  = 2.0
        
        listener?.didPrepareView()
    }
    
    @IBAction
    private func onActionButtonTap() {
        listener?.didSelectAction()
    }
    
    // MARK: - ShiftsPresentable
    
    func showShifts(_ shifts: [ShiftVM]) {
        self.shifts = shifts
        
        tableView.reloadData()
    }
    
    func updateActionTitle(to newTitle: String) {
        actionButton.setTitle(newTitle, for: UIControl.State())
    }
    
    func showAction() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.actionButton.alpha = 1.0
        }) { finished in
            self.actionButton.alpha = 1.0
        }
    }
    
    func hideAction() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.actionButton.alpha = 0.0
        }) { finished in
            self.actionButton.alpha = 0.0
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ShiftsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

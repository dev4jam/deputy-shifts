//
//  RootViewController.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SVProgressHUD

protocol RootPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
    private var targetViewController: ViewControllable?
    private var animationInProgress = false

    weak var listener: RootPresentableListener?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Config.preferredStatusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHUD()
        
        view.backgroundColor = UIColor.white
    }
    
    private func configureHUD() {
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setMaximumDismissTimeInterval(2)
        SVProgressHUD.setDefaultStyle(.dark)
    }

    // MARK: - RootViewControllable
    
    func presentInitialView(_ view: ViewControllable) {
        targetViewController = view
        
        guard !animationInProgress else { return }
        
        animationInProgress = true
        
        let controller = view.uiviewController
        
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        controller.view.backgroundColor = .clear
        
        present(view.uiviewController, animated: true) { [weak self] in
            self?.animationInProgress = false
            self?.targetViewController = nil
        }
    }
}

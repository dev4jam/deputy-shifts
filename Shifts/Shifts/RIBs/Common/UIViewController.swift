//
//  UIViewController.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import RIBs

extension UIViewController {
    func present(view: ViewControllable) {
        present(view.uiviewController, animated: true, completion: nil)
    }

    func dismiss(view: ViewControllable, animated: Bool) {
        view.uiviewController.dismiss(animated: animated, completion: nil)
    }

    func push(view: ViewControllable, animated: Bool) {
        navigationController?.pushViewController(view.uiviewController, animated: animated)
    }

    func pop(view: ViewControllable, animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }    
}

//
//  LoadingPresentable.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol LoadingPresentable: class {
    func showLoading(with status: String?)
    func showError(with status: String?)

    func hideLoading()
}

extension UIViewController: LoadingPresentable {
    func showLoading(with status: String?) {
        SVProgressHUD.show(withStatus: status)
    }

    func showError(with status: String?) {
        SVProgressHUD.showError(withStatus: status)
    }

    func hideLoading() {
        SVProgressHUD.dismiss()
    }
}

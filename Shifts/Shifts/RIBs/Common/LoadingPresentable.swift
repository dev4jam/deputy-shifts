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
    func showSuccess(with status: String?)
    func showError(with status: String?)
    func showInfo(with status: String)
    func showProgress(_ progress: Float, title: String?)

    func hideLoading()
}

extension UIViewController: LoadingPresentable {
    func showLoading(with status: String?) {
        SVProgressHUD.show(withStatus: status)
    }

    func showSuccess(with status: String?) {
        SVProgressHUD.showSuccess(withStatus: status)
    }

    func showError(with status: String?) {
        SVProgressHUD.showError(withStatus: status)
    }

    func showInfo(with status: String) {
        SVProgressHUD.showInfo(withStatus: status)
    }

    func hideLoading() {
        SVProgressHUD.dismiss()
    }

    func showProgress(_ progress: Float, title: String?) {
        SVProgressHUD.showProgress(progress, status: title)
    }    
}

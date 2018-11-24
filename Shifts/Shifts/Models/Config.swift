//
//  Config.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import UIKit

struct Config {
    static let storeFilename: String = "shared-store"
    static let defaultTimeout: TimeInterval = 60.0
    static let preferredStatusBarStyle: UIStatusBarStyle = .lightContent
    
    static let serviceBaseUrl: String = "https://apjoqdqpi3.execute-api.us-west-2.amazonaws.com/dmc"
    static let imagesBaseUrl: String = "https://unsplash.it"
    static let serviceAccessToken: String = "a8cf97adadec4e1b734a39bc5aea71b5741cfca1"
}

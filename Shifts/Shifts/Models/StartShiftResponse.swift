//
//  StartShiftResponse.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation

struct StartShiftResponse: Codable {
    let time: String
    let latitude: String
    let longitude: String
}

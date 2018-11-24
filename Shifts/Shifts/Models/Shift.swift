//
//  Shift.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation

struct Shift: Codable {
    let id: Int
    let start: String
    let end: String?
    let startLatitude: String
    let startLongitude: String
    let endLatitude: String
    let endLongitude: String
    let image: String
}

//
//  ShiftVM.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import UIKit

final class ShiftVM {
    let model: Shift
    
    init(model: Shift) {
        self.model = model
    }
    
    var key: Int {
        return model.id
    }
    
    var startedAt: String {
        return model.start.toDateTime()?.toString() ?? Date.distantPast.toString()
    }

    var endedAt: String? {
        return model.end?.toDateTime()?.toString()
    }

    var startLatitude: String {
        return model.startLatitude
    }

    var startLongitude: String {
        return model.startLongitude
    }

    var endLatitude: String {
        return model.endLatitude
    }

    var endLongitude: String {
        return model.endLongitude
    }

    var imageUrl: String {
        return model.image
    }
    
    var image: UIImage?
}

//
//  String.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation

private let dateFormatter = DateFormatter()

extension String {
    public func toDateTime() -> Date? {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return dateFormatter.date(from: self)
    }
}

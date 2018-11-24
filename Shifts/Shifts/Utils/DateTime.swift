//
//  DateTime.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation

private let dateFormatter = DateFormatter()

public extension Date {
    public var timestamp: String {
        return String(format: "%.0f", timeIntervalSince1970 * 1000)
    }
    
    public var timestampInt: Int {
        return Int(round(timeIntervalSince1970 * 1000))
    }
    
    public func add(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
    
    public func toString() -> String {
        dateFormatter.timeZone  = TimeZone(abbreviation: "UTC")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: self)
    }
    
    public func toServerString() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        
        return dateFormatter.string(from: self)
    }
}

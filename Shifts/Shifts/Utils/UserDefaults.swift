//
//  UserDefaults.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation

public extension UserDefaults {
    public static var shared: UserDefaults = UserDefaults(suiteName: Config.storeFilename) ?? UserDefaults.standard
    
    public func reset() {
        removePersistentDomain(forName: Config.storeFilename)
    }
    
    public var lastShiftStartTime: Date? {
        get {
            let value = double(forKey: #function)
            
            return Date(timeIntervalSince1970: value)
        }
        set {
            self.set(newValue?.timeIntervalSince1970, forKey: #function)
            self.synchronize()
        }
    }
}

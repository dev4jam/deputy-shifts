//
//  LocationServiceProtocol.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import CoreLocation
import When

enum LocationError: Error {
    case locationDisabled
    case locationNotAuthorised
    case locationNotFound
    case locationError(String)
    
    public var localizedDescription: String {
        return message
    }
    
    public var message: String {
        switch self {
        case .locationError(let message): return message
        case .locationDisabled: return L10n.locationDisabled
        case .locationNotAuthorised: return L10n.locationNotAuthorised
        case .locationNotFound: return L10n.locationNotFound
        }
    }
}

protocol LocationServiceProtocol {
    var lastLocation: CLLocation? { get }
    
    func discover() -> Promise<CLLocation>
}

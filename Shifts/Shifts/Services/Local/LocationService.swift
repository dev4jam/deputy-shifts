//
//  LocationService.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import When
import CoreLocation

final class LocationService: NSObject, LocationServiceProtocol {
    private var promise: Promise<CLLocation>?
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        return manager
    }()
    
    private func authoriseLocation() {
        locationManager.requestWhenInUseAuthorization()
    }

    private func startLocationDiscovery() {
        guard CLLocationManager.locationServicesEnabled() else {
            promise?.reject(LocationError.locationDisabled)
            return
        }
        
        guard CLLocationManager.authorizationStatus() == .authorizedAlways ||
              CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
                
            authoriseLocation()
            return
        }

        locationManager.requestLocation()
    }
    
    private func findMostRelevantLocation(from locations: [CLLocation]) -> CLLocation? {
        let newLocations = locations
            .filter { $0.horizontalAccuracy > 0 }
            .sorted { $0.horizontalAccuracy < $1.horizontalAccuracy }
        
        return newLocations.first
    }
    
    // MARK: - LocationServiceProtocol
    
    var lastLocation: CLLocation? {
        return locationManager.location
    }
    
    func discover() -> Promise<CLLocation> {
        let promise = Promise<CLLocation>()
        
        self.promise = promise
        
        DispatchQueue.main.async {
            self.startLocationDiscovery()
        }
        
        return promise
    }
}

// MARK: - CLLocationManager delegate methods

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: Array <CLLocation>) {
        let newLocation = findMostRelevantLocation(from: locations)
        
        if let location = newLocation {
            promise?.resolve(location)
        } else {
            promise?.reject(LocationError.locationNotFound)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        promise?.reject(error)
    }
}

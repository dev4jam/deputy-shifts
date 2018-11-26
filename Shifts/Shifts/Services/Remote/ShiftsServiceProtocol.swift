//
//  ShiftsServiceProtocol.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 26/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import When
import UIKit

protocol ShiftsServiceProtocol: AutoMockable {
    init(networkService: NetworkServiceProtocol, imageService: NetworkServiceProtocol)
    
    func getShifts() -> Promise<[Shift]>
    func startShift(latitude: Double, longitude: Double) -> Promise<Bool>
    func stopShift(latitude: Double, longitude: Double) -> Promise<Bool>
    func getShiftImage(url: String) -> Promise<UIImage>
}

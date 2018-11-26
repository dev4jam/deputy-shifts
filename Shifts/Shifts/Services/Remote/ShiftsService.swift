//
//  StartShiftOperation.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import When

private final class StartShiftOperation: PlainTextOperation {
    init(time: Date, latitude: Double, longitude: Double) {
        super.init()
        
        let body: RequestBody = .json([
            "time": time.toServerString(),
            "latitude": "\(latitude)",
            "longitude": "\(longitude)"
        ])
        
        request = Request(method: .post, endpoint: "/shift/start",
                          params: nil, fields: nil, body: body)
    }
}

private final class StopShiftOperation: PlainTextOperation {
    init(time: Date, latitude: Double, longitude: Double) {
        super.init()
        
        let body: RequestBody = .json([
            "time": time.toServerString(),
            "latitude": "\(latitude)",
            "longitude": "\(longitude)"
        ])

        request = Request(method: .post, endpoint: "/shift/end",
                          params: nil, fields: nil, body: body)
    }
}

private final class GetShiftsOperation: ModelOperation<[Shift]?> {
    override init() {
        super.init()
        
        request = Request(method: .get, endpoint: "/shifts",
                          params: nil, fields: nil, body: nil)
    }
}

private final class GetShiftImageOperation: ImageOperation {
    init(url: String) {
        super.init()
        
        request = Request(method: .get, endpoint: url,
                          params: nil, fields: nil, body: nil)
    }
}

final class ShiftsService: ShiftsServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let imageService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol, imageService: NetworkServiceProtocol) {
        self.networkService = networkService
        self.imageService = imageService
    }
    
    func getShifts() -> Promise<[Shift]> {
        return GetShiftsOperation()
            .execute(in: networkService)
            .then { response -> [Shift] in
                if let shifts = response {
                    return shifts
                }
                
                return []
            }
    }
    
    func startShift(latitude: Double, longitude: Double) -> Promise<Bool> {
        return StartShiftOperation(time: Date(), latitude: latitude, longitude: longitude)
            .execute(in: networkService)
            .then { response -> Bool in
                return response != nil
            }
    }
    
    func stopShift(latitude: Double, longitude: Double) -> Promise<Bool> {
        return StopShiftOperation(time: Date(), latitude: latitude, longitude: longitude)
            .execute(in: networkService)
            .then { response -> Bool in
                return response != nil
            }
    }
    
    func getShiftImage(url: String) -> Promise<UIImage> {
        return GetShiftImageOperation(url: url)
            .execute(in: imageService)
            .then { response -> UIImage in
                if let image = response {
                    return image
                }
                
                throw NetworkError.missingData("Missing image")
            }
    }
}

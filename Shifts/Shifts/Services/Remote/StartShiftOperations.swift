//
//  StartShiftOperation.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation

final class StartShiftOperation: ModelOperation<StartShiftResponse> {
    init(time: Date, latitude: Double, longitude: Double) {
        super.init()
        
        let body: RequestBody = RequestBody.json([
            "time": time.toServerString(),
            "latitude": "\(latitude)",
            "longitude": "\(longitude)"
        ])
        
        request = Request(method: .post, endpoint: "/shift/start",
                          params: nil, fields: nil, body: body)
    }
}

final class StopShiftOperation: ModelOperation<StopShiftResponse> {
    init(time: Date, latitude: Double, longitude: Double) {
        super.init()
        
        let body: RequestBody = RequestBody.json([
            "time": time.toServerString(),
            "latitude": "\(latitude)",
            "longitude": "\(longitude)"
        ])
        
        request = Request(method: .post, endpoint: "/shift/end",
                          params: nil, fields: nil, body: body)
    }
}

final class GetShiftsOperation: ModelOperation<[Shift]?> {
    override init() {
        super.init()
        
        request = Request(method: .get, endpoint: "/shifts",
                          params: nil, fields: nil, body: nil)
    }
}

final class GetShiftImageOperation: ImageOperation {
    override init() {
        super.init()
        
        request = Request(method: .get, endpoint: "/500/500/?random",
                          params: nil, fields: nil, body: nil)
    }
}

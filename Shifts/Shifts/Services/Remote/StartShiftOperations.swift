//
//  StartShiftOperation.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation

final class StartShiftOperation: PlainTextOperation {
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

final class StopShiftOperation: PlainTextOperation {
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

final class GetShiftsOperation: ModelOperation<[Shift]?> {
    override init() {
        super.init()
        
        request = Request(method: .get, endpoint: "/shifts",
                          params: nil, fields: nil, body: nil)
    }
}

final class GetShiftImageOperation: ImageOperation {
    init(url: String) {
        super.init()
        
        request = Request(method: .get, endpoint: url,
                          params: nil, fields: nil, body: nil)
    }
}

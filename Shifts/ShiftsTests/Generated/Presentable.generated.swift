// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import RIBs
import RxSwift

@testable import Shifts













final class RootPresentableMock: RootPresentable {
    var listener: RootPresentableListener?

}

final class ShiftsPresentableMock: ShiftsPresentable {
    var listener: ShiftsPresentableListener?

    //MARK: - showShifts

    var showShiftsCallsCount = 0
    var showShiftsCalled: Bool {
        return showShiftsCallsCount > 0
    }
    var showShiftsReceivedShifts: [ShiftVM]?
    var showShiftsHandler: (([ShiftVM]) -> Void)?

    func showShifts(_ shifts: [ShiftVM]) {
        showShiftsCallsCount += 1
        showShiftsReceivedShifts = shifts
        showShiftsHandler?(shifts)
    }

}


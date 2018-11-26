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

    //MARK: - updateActionTitle

    var updateActionTitleToCallsCount = 0
    var updateActionTitleToCalled: Bool {
        return updateActionTitleToCallsCount > 0
    }
    var updateActionTitleToReceivedNewTitle: String?
    var updateActionTitleToHandler: ((String) -> Void)?

    func updateActionTitle(to newTitle: String) {
        updateActionTitleToCallsCount += 1
        updateActionTitleToReceivedNewTitle = newTitle
        updateActionTitleToHandler?(newTitle)
    }

    //MARK: - showAction

    var showActionCallsCount = 0
    var showActionCalled: Bool {
        return showActionCallsCount > 0
    }
    var showActionHandler: (() -> Void)?

    func showAction() {
        showActionCallsCount += 1
        showActionHandler?()
    }

    //MARK: - hideAction

    var hideActionCallsCount = 0
    var hideActionCalled: Bool {
        return hideActionCallsCount > 0
    }
    var hideActionHandler: (() -> Void)?

    func hideAction() {
        hideActionCallsCount += 1
        hideActionHandler?()
    }

    //MARK: - showLoading

    var showLoadingWithCallsCount = 0
    var showLoadingWithCalled: Bool {
        return showLoadingWithCallsCount > 0
    }
    var showLoadingWithReceivedStatus: String?
    var showLoadingWithHandler: ((String?) -> Void)?

    func showLoading(with status: String?) {
        showLoadingWithCallsCount += 1
        showLoadingWithReceivedStatus = status
        showLoadingWithHandler?(status)
    }

    //MARK: - showError

    var showErrorWithCallsCount = 0
    var showErrorWithCalled: Bool {
        return showErrorWithCallsCount > 0
    }
    var showErrorWithReceivedStatus: String?
    var showErrorWithHandler: ((String?) -> Void)?

    func showError(with status: String?) {
        showErrorWithCallsCount += 1
        showErrorWithReceivedStatus = status
        showErrorWithHandler?(status)
    }

    //MARK: - hideLoading

    var hideLoadingCallsCount = 0
    var hideLoadingCalled: Bool {
        return hideLoadingCallsCount > 0
    }
    var hideLoadingHandler: (() -> Void)?

    func hideLoading() {
        hideLoadingCallsCount += 1
        hideLoadingHandler?()
    }

}


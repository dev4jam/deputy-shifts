// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import RIBs
import RxSwift

@testable import Shifts













final class RootRoutingMock: RootRouting {
    var viewControllable: ViewControllable

    // Variables
    var interactable: Interactable { didSet { interactableSetCallCount += 1 } }
    private (set) var interactableSetCallCount = 0
    var children: [Routing] = [Routing]() { didSet { childrenSetCallCount += 1 } }
    private (set) var childrenSetCallCount = 0
    var lifecycleSubject: PublishSubject<RouterLifecycle> = PublishSubject<RouterLifecycle>() { didSet { lifecycleSubjectSetCallCount += 1 } }
    private (set) var lifecycleSubjectSetCallCount = 0
    var lifecycle: Observable<RouterLifecycle> { return lifecycleSubject }

    // Function Handlers
    var loadHandler: (() -> ())?
    private (set) var loadCallCount: Int = 0
    var attachChildHandler: ((_ child: Routing) -> ())?
    private (set) var attachChildCallCount: Int = 0
    var detachChildHandler: ((_ child: Routing) -> ())?
    private (set) var detachChildCallCount: Int = 0


    init(interactable: Interactable, viewController: ViewControllable) {
        self.interactable = interactable
        self.viewControllable = viewController
    }

    func load() {
        loadCallCount += 1

        if let handler = loadHandler {
            return handler()
        }
    }

    func attachChild(_ child: Routing) {
        attachChildCallCount += 1

        if let handler = attachChildHandler {
            return handler(child)
        }
    }

    func detachChild(_ child: Routing) {
        detachChildCallCount += 1

        if let handler = detachChildHandler {
            return handler(child)
        }
    }

}

final class ShiftsRoutingMock: ShiftsRouting {
    var viewControllable: ViewControllable

    // Variables
    var interactable: Interactable { didSet { interactableSetCallCount += 1 } }
    private (set) var interactableSetCallCount = 0
    var children: [Routing] = [Routing]() { didSet { childrenSetCallCount += 1 } }
    private (set) var childrenSetCallCount = 0
    var lifecycleSubject: PublishSubject<RouterLifecycle> = PublishSubject<RouterLifecycle>() { didSet { lifecycleSubjectSetCallCount += 1 } }
    private (set) var lifecycleSubjectSetCallCount = 0
    var lifecycle: Observable<RouterLifecycle> { return lifecycleSubject }

    // Function Handlers
    var loadHandler: (() -> ())?
    private (set) var loadCallCount: Int = 0
    var attachChildHandler: ((_ child: Routing) -> ())?
    private (set) var attachChildCallCount: Int = 0
    var detachChildHandler: ((_ child: Routing) -> ())?
    private (set) var detachChildCallCount: Int = 0


    init(interactable: Interactable, viewController: ViewControllable) {
        self.interactable = interactable
        self.viewControllable = viewController
    }

    func load() {
        loadCallCount += 1

        if let handler = loadHandler {
            return handler()
        }
    }

    func attachChild(_ child: Routing) {
        attachChildCallCount += 1

        if let handler = attachChildHandler {
            return handler(child)
        }
    }

    func detachChild(_ child: Routing) {
        detachChildCallCount += 1

        if let handler = detachChildHandler {
            return handler(child)
        }
    }

}


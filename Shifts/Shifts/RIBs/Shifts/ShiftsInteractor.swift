//
//  ShiftsInteractor.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import RIBs
import RxSwift

protocol ShiftsRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ShiftsPresentable: Presentable {
    var listener: ShiftsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func showShifts(_ shifts: [ShiftVM])
    func updateActionTitle(to newTitle: String)
}

protocol ShiftsListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ShiftsInteractor: PresentableInteractor<ShiftsPresentable>, ShiftsInteractable, ShiftsPresentableListener {
    private let networkService: NetworkServiceProtocol
    private let imageService: NetworkServiceProtocol

    weak var router: ShiftsRouting?
    weak var listener: ShiftsListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: ShiftsPresentable,
         networkService: NetworkServiceProtocol,
         imageService: NetworkServiceProtocol) {
        
        self.networkService = networkService
        self.imageService = imageService
        
        super.init(presenter: presenter)
        
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - ShiftsPresentableListener
    
    func didPrepareView() {
        
    }
    
    func didSelectAction() {
        
    }
}

//
//  ShiftsInteractor.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import RIBs
import RxSwift
import CoreLocation

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
    private let locationService: LocationServiceProtocol
    private let state: Variable<AppState>

    weak var router: ShiftsRouting?
    weak var listener: ShiftsListener?
    
    private var isShiftStarted: Bool = false
    private var location: CLLocation? = nil

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: ShiftsPresentable,
         networkService: NetworkServiceProtocol,
         imageService: NetworkServiceProtocol,
         locationService: LocationServiceProtocol,
         state: Variable<AppState>) {
        
        self.networkService  = networkService
        self.imageService    = imageService
        self.locationService = locationService
        self.state           = state
        
        super.init(presenter: presenter)
        
        presenter.listener = self
    }
    
    private func updateLocation() {
        locationService.discover()
            .done { [weak self] (location) in
                guard let this = self else { return }
                
                this.location = location
            }
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        state.asObservable()
            .subscribe(onNext: { [weak self] (newState) in
                guard let this = self else { return }
                
                this.updateLocation()
            }).disposeOnDeactivate(interactor: self)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func updateAction() {
        let newActionTitle = isShiftStarted ? L10n.stop : L10n.start
        
        presenter.updateActionTitle(to: newActionTitle)
    }
    
    // MARK: - ShiftsPresentableListener
    
    func didPrepareView() {
        updateAction()
    }
    
    func didSelectAction() {
        isShiftStarted = !isShiftStarted
        
        updateAction()
    }
}

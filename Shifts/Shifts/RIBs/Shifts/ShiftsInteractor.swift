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

protocol ShiftsPresentable: Presentable, LoadingPresentable {
    var listener: ShiftsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func showShifts(_ shifts: [ShiftVM])
    func updateActionTitle(to newTitle: String)
    
    func showAction()
    func hideAction()
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
    
    private func revertAction() {
        isShiftStarted = !isShiftStarted
        
        updateAction()
    }
    
    private func reloadShifts() {
        presenter.showLoading(with: L10n.loading)
        
        GetShiftsOperation()
            .execute(in: networkService)
            .done { [weak self] (shiftsInResponse) in
                guard let this = self else { return }

                if let shifts = shiftsInResponse, !shifts.isEmpty {
                    guard let shift = shifts.first else { fatalError() }
                    
                    this.isShiftStarted = shift.end != nil
                    
                    this.presenter.showShifts(shifts.map { ShiftVM(model: $0) })
                } else {
                    this.isShiftStarted = false
                }
                
                this.updateAction()
                this.presenter.showAction()
                this.presenter.hideLoading()
            }
            .fail { [weak self]  (error) in
                guard let this = self else { return }

                this.presenter.showError(with: error.localizedDescription)
            }
    }
    
    private func updateAction() {
        let newActionTitle = isShiftStarted ? L10n.stop : L10n.start
        
        presenter.updateActionTitle(to: newActionTitle)
    }

    private func startShift() {
        
    }
    
    private func stopShift() {
        
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        state.asObservable()
            .subscribe(onNext: { [weak self] (newState) in
                guard let this = self else { return }
                
                this.updateLocation()
                this.reloadShifts()
            }).disposeOnDeactivate(interactor: self)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - ShiftsPresentableListener
    
    func didPrepareView() {
        reloadShifts()
        updateAction()
    }
    
    func didSelectAction() {
        presenter.hideAction()
        
        if isShiftStarted {
            stopShift()
        } else {
            startShift()
        }
        
        isShiftStarted = !isShiftStarted
        
        updateAction()
        reloadShifts()
    }
}

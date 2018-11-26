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
    private let service: ShiftsServiceProtocol
    private let locationService: LocationServiceProtocol
    private let state: Variable<AppState>

    weak var router: ShiftsRouting?
    weak var listener: ShiftsListener?
    
    private var isShiftStarted: Bool = false
    private var location: CLLocation? = nil

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: ShiftsPresentable,
         service: ShiftsServiceProtocol,
         locationService: LocationServiceProtocol,
         state: Variable<AppState>) {
        
        self.service         = service
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
    
    private func parseReloadShiftsNetworkError(_ error: NetworkError) {
        switch error {
        case .missingData(_):
            isShiftStarted = false
            
            updateAction()
            presenter.showAction()
            presenter.hideLoading()
            
        default:
            presenter.showError(with: error.localizedDescription)
        }
    }

    private func parseStartStopShiftNetworkError(_ error: NetworkError) {
        switch error {
        case .missingData(_):
            presenter.hideLoading()
            reloadShifts()

        default:
            presenter.showError(with: error.localizedDescription)
        }
    }
    
    private func parseShifts(_ shifts: [Shift]) {
        if !shifts.isEmpty {
            guard let shift = shifts.last else { fatalError() }
            
            isShiftStarted = shift.end.isEmpty
            
            let sortedShifts = shifts
                .sorted { $0.id > $1.id }
                .map { ShiftVM(model: $0) }
            
            presenter.showShifts(sortedShifts)
        } else {
            isShiftStarted = false
        }
        
        updateAction()
        presenter.showAction()
    }

    private func reloadShifts() {
        presenter.showLoading(with: L10n.loading)
        
        service.getShifts()
            .done { [weak self] (shifts) in
                guard let this = self else { return }

                this.parseShifts(shifts)
                this.presenter.hideLoading()
            }
            .fail { [weak self]  (error) in
                guard let this = self else { return }

                if let netError = error as? NetworkError {
                    this.parseReloadShiftsNetworkError(netError)
                } else {
                    this.presenter.showError(with: error.localizedDescription)
                }
            }
    }
    
    private func updateAction() {
        let newActionTitle = isShiftStarted ? L10n.stop : L10n.start
        
        presenter.updateActionTitle(to: newActionTitle)
    }

    private func startShift() {
        guard let location = self.location else {
            presenter.showError(with: L10n.locationFailed)
            revertAction()
            return
        }
        
        presenter.showLoading(with: L10n.starting)
        
        service.startShift(latitude: location.coordinate.latitude,
                           longitude: location.coordinate.longitude)
            .done { [weak self] (response) in
                guard let this = self else { return }
                
                this.reloadShifts()
            }
            .fail { [weak self]  (error) in
                guard let this = self else { return }
                
                if let netError = error as? NetworkError {
                    this.parseStartStopShiftNetworkError(netError)
                } else {
                    this.presenter.showError(with: error.localizedDescription)
                }
            }
    }
    
    private func stopShift() {
        guard let location = self.location else {
            presenter.showError(with: L10n.locationFailed)
            revertAction()
            return
        }
        
        presenter.showLoading(with: L10n.stopping)
        
        service.stopShift(latitude: location.coordinate.latitude,
                          longitude: location.coordinate.longitude)
            .done { [weak self] (response) in
                guard let this = self else { return }
                
                this.reloadShifts()
            }
            .fail { [weak self]  (error) in
                guard let this = self else { return }
                
                if let netError = error as? NetworkError {
                    this.parseStartStopShiftNetworkError(netError)
                } else {
                    this.presenter.showError(with: error.localizedDescription)
                }
            }
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
        updateAction()
    }
    
    func didRequestImage(for shift: ShiftVM) {
        guard shift.image.value == nil else { return }
        guard !shift.imageUrl.isEmpty else { return }
        
        service.getShiftImage(url: shift.imageUrl)
            .done { (image) in
                shift.image.value = image
            }
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
    }
}

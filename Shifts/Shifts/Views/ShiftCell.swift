//
//  ShiftCell.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import UIKit
import RxSwift

final class ShiftCell: UITableViewCell {
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var startLabel: UILabel!
    @IBOutlet private weak var stopLabel: UILabel!
    
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        // Unsubscribe from previous subscription
        
        disposeBag = DisposeBag()
    }

    func show(shift: ShiftVM) {
        startLabel.text = L10n.startedOn(shift.startedAt)
        
        if let endedAt = shift.endedAt {
            stopLabel.text = L10n.stoppedOn(endedAt)
        } else {
            stopLabel.text = nil
        }
        
        iconView.image = shift.image.value
        
        shift.image
            .asObservable()
            .subscribe(onNext: { [weak self] (newImage) in
                guard let this = self else { return }
                
                this.iconView.image = newImage
                
            }).disposed(by: disposeBag)
    }
}

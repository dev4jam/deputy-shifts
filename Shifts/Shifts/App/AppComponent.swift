//
//  AppComponent.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import Foundation
import RIBs
import UIKit
import RxSwift

final class AppComponent: Component<EmptyDependency>, RootDependency {
    let networkService: NetworkServiceProtocol
    let imageService: NetworkServiceProtocol
    let state: Variable<AppState>

    init(application: UIApplication,
         launchOptions: [UIApplication.LaunchOptionsKey : Any]?,
         state: Variable<AppState>) {
        
        self.state = state
        
        networkService = NetworkService(baseUrl: Config.serviceBaseUrl,
                                        auth: .token(Config.serviceAccessToken),
                                        headers: [:])

        imageService = NetworkService(baseUrl: Config.imagesBaseUrl,
                                      auth: nil, headers: [:])

        super.init(dependency: EmptyComponent())
    }
}

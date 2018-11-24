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

final class AppComponent: Component<EmptyDependency>, RootDependency {
    let networkService: NetworkServiceProtocol
    let imageService: NetworkServiceProtocol

    init(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        networkService = NetworkService(baseUrl: Config.serviceBaseUrl,
                                        auth: .token(Config.serviceAccessToken),
                                        headers: [:])

        imageService = NetworkService(baseUrl: Config.imagesBaseUrl,
                                      auth: nil, headers: [:])

        super.init(dependency: EmptyComponent())
    }
}

//
//  AppConfigurator.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 30/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

struct AppConfigurator {
    func configure(window: UIWindow) {
        let heroListViewController = HeroListViewController()
        let navigationController = UINavigationController(rootViewController: heroListViewController)
        navigationController.navigationBar.prefersLargeTitles = true

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

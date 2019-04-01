//
//  FavoriteServiceProvider.swift
//  Marvel
//
//  Created by lucas.cardinali on 3/28/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

struct FavoriteServiceProvider: FavoriteService {

    let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func isFavorited(id: Int) -> Bool {
        return userDefaults.bool(forKey: "\(id)")
    }

    func favoriteHero(id: Int) {
        userDefaults.set(true, forKey: "\(id)")
        userDefaults.synchronize()
    }

    func unfavoriteHero(id: Int) {
        userDefaults.removeObject(forKey: "\(id)")
        userDefaults.synchronize()
    }
}

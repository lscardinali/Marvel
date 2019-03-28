//
//  FavoriteRepository.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 28/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

class FavoriteRepository {

    let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func isFavorited(id: Int) -> Bool {
        return userDefaults.bool(forKey: "\(id)")
    }

    func favoriteHero(id: Int) {
        return userDefaults.set(true, forKey: "\(id)")
    }

    func unfavoriteHero(id: Int) {
        return userDefaults.removeObject(forKey: "\(id)")
    }

}

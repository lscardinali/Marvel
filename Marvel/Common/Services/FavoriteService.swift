//
//  FavoriteService.swift
//  Marvel
//
//  Created by lucas.cardinali on 3/28/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

protocol FavoriteService {
    func isFavorited(id: Int) -> Bool
    func favoriteHero(id: Int)
    func unfavoriteHero(id: Int)
}

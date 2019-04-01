//
//  FavoriteServiceProviderTest.swift
//  MarvelTests
//
//  Created by Lucas Salton Cardinali on 31/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import XCTest

@testable import Marvel

class FavoriteServiceProviderTest: XCTestCase {

    var sut: FavoriteServiceProvider!
    var userDefaults: UserDefaults!

    let heroId = 1

    override func setUp() {
        userDefaults = UserDefaults()
        sut = FavoriteServiceProvider(userDefaults: userDefaults)
    }

    override func tearDown() {
        userDefaults = nil
        sut = nil
    }

    func testFavorite() {
        sut.favoriteHero(id: heroId)
        XCTAssertTrue(sut.isFavorited(id: heroId))
    }

    func testUnfavorite() {
        sut.favoriteHero(id: heroId)
        XCTAssertTrue(sut.isFavorited(id: heroId))
        sut.unfavoriteHero(id: heroId)
        XCTAssertFalse(sut.isFavorited(id: heroId))
    }
}

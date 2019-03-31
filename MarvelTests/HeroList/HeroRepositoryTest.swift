//
//  HeroRepositoryTest.swift
//  MarvelTests
//
//  Created by Lucas Salton Cardinali on 31/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import XCTest

@testable import Marvel

class HeroRepositoryTest: XCTestCase {

    var sut: HeroRepository!
    var favoriteStub: FavoriteProviderStub!

    override func setUp() {
        favoriteStub = FavoriteProviderStub()
        sut = HeroRepository(marvelProvider: MarvelProviderStub(), favoriteProvider: favoriteStub)
    }

    override func tearDown() {
        favoriteStub = nil
        sut = nil
    }

    func testFetchingOfHeroes() {
        XCTAssertTrue(self.sut.currentPage == 0)
        XCTAssertFalse(self.sut.hasReachedEnd)
        XCTAssertTrue(self.sut.currentViewModels().isEmpty)

        sut.fetchHeroes { result in
            switch result {
            case let .success(viewModels):
                XCTAssert(!viewModels.isEmpty)
                XCTAssertEqual(self.sut.currentPage, 1)
                XCTAssertTrue(self.sut.hasReachedEnd)
                XCTAssertFalse(self.sut.currentViewModels().isEmpty)
                XCTAssertNotNil(self.sut.heroAt(index: 0))
                XCTAssertEqual(self.sut.heroAt(index: 0).name, "3-D Man")

                self.sut.resetResults()

                XCTAssertTrue(self.sut.currentViewModels().isEmpty)
                XCTAssertEqual(self.sut.currentPage, 0)
                XCTAssertFalse(self.sut.hasReachedEnd)
                XCTAssertTrue(self.sut.currentViewModels().isEmpty)
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testFavoritingHeroes() {
        XCTAssert(favoriteStub.favorited.isEmpty)
        sut.fetchHeroes { result in
            switch result {
            case .success:
                self.sut.toggleFavoriteHeroAtIndex(0)
                XCTAssertFalse(self.favoriteStub.favorited.isEmpty)
                XCTAssertTrue(self.favoriteStub.favorited.contains(1011334))
                self.sut.toggleFavoriteHeroAtIndex(0)
                XCTAssertTrue(self.favoriteStub.favorited.isEmpty)
                XCTAssertFalse(self.favoriteStub.favorited.contains(1011334))
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testFailureFetchingOfHeroes() {
        sut = HeroRepository(marvelProvider: MarvelProviderFailureStub(), favoriteProvider: FavoriteProviderStub())
        sut.fetchHeroes { result in
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case let .failure(error):
                XCTAssert(error is Error)
            }
        }
    }
}

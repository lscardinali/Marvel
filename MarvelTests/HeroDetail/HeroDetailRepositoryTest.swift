//
//  HeroDetailRepositoryTest.swift
//  MarvelTests
//
//  Created by Lucas Salton Cardinali on 31/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import XCTest

@testable import Marvel

class HeroDetailRepositoryTest: XCTestCase {

    var sut: HeroDetailRepository!
    var favoriteStub: FavoriteProviderStub!
    var hero: MarvelHero!

    override func setUp() {
        favoriteStub = FavoriteProviderStub()
        hero = MarvelHero(id: 1, name: "Hero Name", description: "",
                          thumbnail: Thumbnail(path: "", thumbnailExtension: ""))
        sut = HeroDetailRepository(hero: hero, marvelProvider: MarvelProviderStub(), favoriteProvider: favoriteStub)
    }

    override func tearDown() {
        favoriteStub = nil
        sut = nil
    }

    func testFetchingOfHeroes() {
        XCTAssertNotNil(sut.currentViewModel)
        XCTAssertTrue(sut.currentViewModel.comics.isEmpty)
        XCTAssertTrue(sut.currentViewModel.stories.isEmpty)
        XCTAssertTrue(sut.currentViewModel.events.isEmpty)
        XCTAssertTrue(sut.currentViewModel.series.isEmpty)

        sut.fetchHeroDetails { result in
            switch result {
            case let .success(viewModel):
                XCTAssertFalse(viewModel.comics.isEmpty)
                XCTAssertFalse(viewModel.stories.isEmpty)
                XCTAssertFalse(viewModel.events.isEmpty)
                XCTAssertFalse(viewModel.series.isEmpty)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testFavoritingHeroes() {
        XCTAssert(favoriteStub.favorited.isEmpty)
        sut.toggleFavoriteHero()
        XCTAssert(favoriteStub.favorited.contains(1))
        sut.toggleFavoriteHero()
        XCTAssert(favoriteStub.favorited.isEmpty)
    }

    func testFailureFetchingOfDetails() {
        sut = HeroDetailRepository(hero: hero, marvelProvider: MarvelProviderFailureStub(),
                                   favoriteProvider: favoriteStub)
        sut.fetchHeroDetails { result in
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
}

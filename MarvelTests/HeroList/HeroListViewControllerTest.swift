//
//  HeroListViewControllerTest.swift
//  MarvelTests
//
//  Created by Lucas Salton Cardinali on 31/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import XCTest

@testable import Marvel

class HeroListViewControllerTest: XCTestCase {

    var sut: HeroListViewController!
    var sutView: HeroListView!

    override func setUp() {
        sutView = HeroListView()
    }

    override func tearDown() {
        sut = nil
        sutView = nil
    }

    func testFetchHeroes() {
        let repository = HeroRepository(marvelProvider: MarvelProviderStub(),
                                        favoriteProvider: FavoriteProviderStub())
        sut = HeroListViewController(repository: repository, view: sutView)
        sut.fetchHeroes()
        XCTAssertFalse(sutView.tableView.isHidden)
        XCTAssertEqual(sutView.tableView.numberOfRows(inSection: 0), 5)
    }

    func testFetchEmptyHeroes() {
        let repository = HeroRepository(marvelProvider: MarvelProviderStub(emptyStub: true),
                                        favoriteProvider: FavoriteProviderStub())
        sut = HeroListViewController(repository: repository, view: sutView)

        sut.fetchHeroes()
        XCTAssertTrue(sutView.tableView.isHidden)
        XCTAssertEqual(sutView.tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(sutView.statusLabel.text, "Couldnt find any hero :(")
    }

    func testFetchError() {
        let repository = HeroRepository(marvelProvider: MarvelProviderFailureStub(),
                                        favoriteProvider: FavoriteProviderStub())
        sut = HeroListViewController(repository: repository, view: sutView)

        sut.fetchHeroes()
        XCTAssertTrue(sutView.tableView.isHidden)
        XCTAssertEqual(sutView.statusLabel.text, "There was a problem loading the heroes")
    }

    func testValidSearch() {
        let repository = HeroRepository(marvelProvider: MarvelProviderStub(),
                                        favoriteProvider: FavoriteProviderStub())
        sut = HeroListViewController(repository: repository, view: sutView)
        sut.heroSearchController.searchBar.text = "Spider"
        sut.heroSearchController.searchBar.delegate?.searchBarTextDidEndEditing?(sut.heroSearchController.searchBar)
        XCTAssertEqual(sutView.tableView.numberOfRows(inSection: 0), 5)
    }

    func testInvalidSearch() {
        let repository = HeroRepository(marvelProvider: MarvelProviderStub(),
                                        favoriteProvider: FavoriteProviderStub())
        sut = HeroListViewController(repository: repository, view: sutView)
        sut.heroSearchController.searchBar.text = "Sp"
        sut.heroSearchController.searchResultsUpdater?.updateSearchResults(for: sut.heroSearchController)
        XCTAssertEqual(sutView.tableView.numberOfRows(inSection: 0), 0)

        sut.heroSearchController.searchBar.delegate?.searchBarCancelButtonClicked?(sut.heroSearchController.searchBar)
        XCTAssertEqual(sutView.tableView.numberOfRows(inSection: 0), 5)
    }
}

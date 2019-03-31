//
//  HeroListViewTest.swift
//  MarvelTests
//
//  Created by Lucas Salton Cardinali on 31/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import XCTest

@testable import Marvel

class HeroListDelegateStub: HeroListViewDelegate {

    var hasSelectedItem = false
    var hasFavorited = false

    func didSelectItemAtIndex(index: Int) {
        hasSelectedItem = true
    }

    func didFavouriteItemAtIndex(_ index: Int) {
        hasFavorited = true
    }

    func isReachingEndOfList() {
    }
}

class HeroListViewTest: XCTestCase {

    var sut: HeroListView!
    var delegateStub: HeroListDelegateStub!

    override func setUp() {
        delegateStub = HeroListDelegateStub()
        sut = HeroListView()
        sut.delegate = delegateStub
    }

    override func tearDown() {
        delegateStub = nil
        sut = nil
    }

    func viewModels() -> [HeroCellViewModel] {
        return [
            HeroCellViewModel(id: 1, heroName: "Hero 1", heroThumbnail: "http://google.com", favorited: true),
            HeroCellViewModel(id: 2, heroName: "Hero 2", heroThumbnail: "http://google.com", favorited: true),
            HeroCellViewModel(id: 3, heroName: "Hero 3", heroThumbnail: "http://google.com", favorited: false)
        ]
    }

    func testStates() {
        sut.setState(state: .loadingData)
        XCTAssertTrue(sut.tableView.isHidden)
        XCTAssertTrue(sut.statusLabel.isHidden)
        XCTAssertFalse(sut.loadingHUD.isHidden)

        sut.setState(state: .errorOnLoad("Error String"))
        XCTAssertTrue(sut.tableView.isHidden)
        XCTAssertFalse(sut.statusLabel.isHidden)
        XCTAssertEqual(sut.statusLabel.text, "Error String")
        XCTAssertTrue(sut.loadingHUD.isHidden)

        sut.setState(state: .loadingMoreData)
        XCTAssertTrue(sut.tableViewActivityIndicator.isAnimating)

        sut.setState(state: .dataLoaded(viewModels()))
        XCTAssertFalse(sut.tableView.isHidden)
        XCTAssertTrue(sut.statusLabel.isHidden)
        XCTAssertTrue(sut.loadingHUD.isHidden)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 3)
        XCTAssert(sut.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) is HeroTableViewCell)

        sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(delegateStub.hasSelectedItem)

        let cell: HeroTableViewCell = sut.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! HeroTableViewCell
        cell.favoriteButton.sendActions(for: .touchDown)
        XCTAssertTrue(delegateStub.hasFavorited)

    }
}

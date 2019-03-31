//
//  HeroTableViewCellTest.swift
//  MarvelTests
//
//  Created by Lucas Salton Cardinali on 31/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import XCTest

@testable import Marvel

class HeroTableViewCellDelegateStub: HeroTableViewCellDelegate {
    var hasFavorited = false

    func didTapFavoriteButton(_ sender: HeroTableViewCell) {
        hasFavorited = true
    }
}

class HeroTableViewCellTest: XCTestCase {

    var sut: HeroTableViewCell!
    var delegateStub: HeroTableViewCellDelegateStub!

    override func setUp() {
        delegateStub = HeroTableViewCellDelegateStub()
        sut = HeroTableViewCell()
        sut.delegate = delegateStub
    }

    override func tearDown() {
        delegateStub = nil
        sut = nil
    }

    func testSetupUnfavorited() {
        sut.setupCell(HeroCellViewModel(id: 1, heroName: "Hero 1", heroThumbnail: "http://google.com", favorited: false))
        XCTAssertEqual(sut.heroNameLabel.text, "Hero 1")
        XCTAssertFalse(sut.favoriteButton.isSelected)
    }

    func testSetupFavorited() {
        sut.setupCell(HeroCellViewModel(id: 2, heroName: "Hero 2", heroThumbnail: "http://google.com", favorited: true))
        XCTAssertEqual(sut.heroNameLabel.text, "Hero 2")
        XCTAssertTrue(sut.favoriteButton.isSelected)
    }

    func testFavoriteButton() {
        sut.setupCell(HeroCellViewModel(id: 1, heroName: "Hero 1", heroThumbnail: "http://google.com", favorited: false))
        sut.favoriteButton.sendActions(for: .touchDown)
        XCTAssertEqual(delegateStub.hasFavorited, true)
    }
}

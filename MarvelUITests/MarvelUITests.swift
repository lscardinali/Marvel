//
//  MarvelUITests.swift
//  MarvelUITests
//
//  Created by Lucas Salton Cardinali on 30/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import XCTest

class MarvelUITests: XCTestCase {

    var app: XCUIApplication!
    let heroCellIdentifier = "HeroTableViewCell"
    let heroDetailCellIdentifier = "HeroDetailHeaderCell"
    let heroDetailContentCellIdentifier = "HeroDetailContentCell"

    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = true
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    func testHeroList() {
        XCTAssert(app.otherElements["LoadingHUD"].isHittable)
        XCTAssertTrue(app.cells.matching(identifier: heroCellIdentifier).firstMatch.waitForExistence(timeout: 10))
        XCTAssert(app.cells.matching(identifier: heroCellIdentifier).count > 0)
    }

    func testHeroFavorite() {
        XCTAssertTrue(app.buttons.matching(identifier: "FavoriteButton").firstMatch.waitForExistence(timeout: 10))
        let favoriteButton = app.buttons.matching(identifier: "FavoriteButton").firstMatch
        favoriteButton.tap()
        XCTAssertTrue(favoriteButton.isSelected)
        sleep(1)
        favoriteButton.tap()
        XCTAssertFalse(favoriteButton.isSelected)
    }

    func testHeroSearch() {
        XCTAssert(app.cells.matching(identifier: heroCellIdentifier).firstMatch.waitForExistence(timeout: 10))
        app.swipeDown()
        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("Spider\n")
        XCTAssert(app.cells.matching(identifier: heroCellIdentifier).firstMatch.waitForExistence(timeout: 15))
        XCTAssert(app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Spider'")).count > 0)
        app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Cancel'")).firstMatch.tap()
        XCTAssert(app.cells.matching(identifier: heroCellIdentifier).firstMatch.waitForExistence(timeout: 10))
        XCTAssert(app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH '3-D Man'")).count > 0)

    }

    func testHeroDetails() {
        XCTAssert(app.cells.matching(identifier: heroCellIdentifier).firstMatch.waitForExistence(timeout: 10))
        app.cells.matching(identifier: heroCellIdentifier).firstMatch.tap()
        XCTAssert(app.cells.matching(identifier: heroDetailCellIdentifier).firstMatch.waitForExistence(timeout: 10))
        app.swipeUp()
        app.swipeDown()
        XCTAssert(app.cells.matching(identifier: heroDetailCellIdentifier).count > 0)
        XCTAssert(app.cells.matching(identifier: heroDetailContentCellIdentifier).count > 0)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssert(app.cells.matching(identifier: heroCellIdentifier).count > 0)
    }

    func testHeroDetailFavorite() {
        XCTAssert(app.cells.matching(identifier: heroCellIdentifier).firstMatch.waitForExistence(timeout: 10))
        app.cells.matching(identifier: heroCellIdentifier).firstMatch.tap()
        XCTAssert(app.cells.matching(identifier: heroDetailCellIdentifier).firstMatch.waitForExistence(timeout: 10))
        let unfavoritedButton = app.buttons.matching(identifier: "UnfavoritedButton").firstMatch
        unfavoritedButton.tap()
        XCTAssert(app.buttons.matching(identifier: "UnfavoritedButton").count == 0)
        let favoritedButton = app.buttons.matching(identifier: "FavoritedButton").firstMatch
        favoritedButton.tap()
        XCTAssert(app.buttons.matching(identifier: "FavoritedButton").count == 0)
    }

}

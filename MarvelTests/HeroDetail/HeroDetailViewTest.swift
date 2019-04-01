//
//  HeroDetailViewTest.swift
//  MarvelTests
//
//  Created by Lucas Salton Cardinali on 31/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import XCTest

@testable import Marvel

class HeroDetailViewTest: XCTestCase {

    var sut: HeroDetailView!

    override func setUp() {
        sut = HeroDetailView()
    }

    override func tearDown() {
        sut = nil
    }

    func viewModel() -> HeroDetailViewModel {
        let content = HeroDetailViewModelContent(thumbnail: "http://google.com", title: "title",
                                                 description: "Description")
        let contents = [content, content, content]

        return HeroDetailViewModel(name: "Hero Name", thumbnail: "http://google.com", favorited: false,
                                   comics: contents, series: contents, events: contents, stories: contents)
    }

    func testStates() {
        sut.setState(.loadingData)
        XCTAssertFalse(sut.tableView.isHidden)
        XCTAssertFalse(sut.loadingHUD.isHidden)

        sut.setState(.errorOnLoad("Error Message"))
        XCTAssertTrue(sut.tableView.isHidden)
        XCTAssertTrue(sut.loadingHUD.isHidden)
        XCTAssertFalse(sut.statusLabel.isHidden)
        XCTAssertEqual(sut.statusLabel.text, "Error Message")

        sut.setState(.dataLoaded(viewModel()))
        XCTAssertFalse(sut.tableView.isHidden)
        XCTAssertTrue(sut.loadingHUD.isHidden)
        XCTAssertTrue(sut.statusLabel.isHidden)

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 1), 3)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 2), 3)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 3), 3)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 4), 3)


        XCTAssert(sut.tableView.dataSource?.tableView(sut.tableView,cellForRowAt: IndexPath(row: 0, section: 0))
            is HeroDetailHeaderCell)
        XCTAssert(sut.tableView.dataSource?.tableView(sut.tableView,cellForRowAt: IndexPath(row: 0, section: 1))
            is HeroDetailContentCell)
        XCTAssert(sut.tableView.dataSource?.tableView(sut.tableView,cellForRowAt: IndexPath(row: 0, section: 2))
            is HeroDetailContentCell)
        XCTAssert(sut.tableView.dataSource?.tableView(sut.tableView,cellForRowAt: IndexPath(row: 0, section: 3))
            is HeroDetailContentCell)
        XCTAssert(sut.tableView.dataSource?.tableView(sut.tableView,cellForRowAt: IndexPath(row: 0, section: 4))
            is HeroDetailContentCell)
    }
}

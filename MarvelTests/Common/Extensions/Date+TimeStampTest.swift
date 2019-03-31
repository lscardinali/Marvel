//
//  Date+TimeStampTest.swift
//  MarvelTests
//
//  Created by Lucas Salton Cardinali on 30/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import XCTest

@testable import Marvel

class DateTimeStampTest: XCTestCase {

    var sut: Date!

    override func setUp() {
        var dateComp = DateComponents()
        dateComp.year = 2018
        dateComp.month = 7
        dateComp.day = 20
        dateComp.timeZone = TimeZone(abbreviation: "BRT")
        let userCalendar = Calendar.current
        sut = userCalendar.date(from: dateComp)
    }

    override func tearDown() {
        sut = nil
    }

    func testCorrectTime() {
        XCTAssertEqual(sut.currentTimeMillis(), 1532055600000)
    }

}

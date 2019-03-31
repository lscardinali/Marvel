//
//  String+MD5Test.swift
//  MarvelTests
//
//  Created by Lucas Salton Cardinali on 30/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import XCTest

@testable import Marvel

class StringMD5Test: XCTestCase {

    var sut: String!

    override func setUp() {
        sut = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    }

    override func tearDown() {
        sut = nil
    }

    func testEncryption() {
        XCTAssertEqual(sut.md5Value, "fc10a08df7fafa3871166646609e1c95", "The hash didn't match the expected result")
    }

    func testFailedEncryption() {
        XCTAssertNotEqual(sut.md5Value, "nonsensehash", "The hash did match the unexpected result")
    }

}

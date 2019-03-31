//
//  String+MD5.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 27/03/19.
//  From: https://stackoverflow.com/questions/32163848/how-can-i-convert-a-string-to-an-md5-hash-in-ios-using-swift
//

import Foundation
import CommonCrypto

extension String {
    var md5Value: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        if let tempDigest = self.data(using: .utf8) {
            _ = tempDigest.withUnsafeBytes { body -> String in
                CC_MD5(body.baseAddress, CC_LONG(tempDigest.count), &digest)
                return ""
            }
        }

        return (0 ..< length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}

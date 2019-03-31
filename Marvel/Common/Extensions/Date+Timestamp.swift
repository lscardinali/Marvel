//
//  Date+Timestamp.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 27/03/19.
//  From: https://stackoverflow.com/questions/46376823/ios-swift-get-the-current-local-time-and-date-timestamp/46390754
//

import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

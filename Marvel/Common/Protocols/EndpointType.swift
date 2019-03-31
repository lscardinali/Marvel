//
//  EndpointType.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 30/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

public protocol EndpointType {
    var baseURL: URL { get }
    var path: String { get }
    var parameters: [String: String] { get }
}

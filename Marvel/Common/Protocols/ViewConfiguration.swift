//
//  ViewConfiguration.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 26/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

protocol ViewConfiguration: class {
    func setupConstraints()
    func buildViewHierarchy()
    func setupView()
}

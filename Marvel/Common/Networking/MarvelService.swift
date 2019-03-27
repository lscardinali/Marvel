//
//  MarvelService.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 26/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

protocol MarvelService {
    func fetchHeroes(offset: Int?,
                     limit: Int?,
                     nameStartsWith: String?,
                     result: @escaping (Result<Data, Error>) -> Void)

}

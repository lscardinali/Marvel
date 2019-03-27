//
//  HeroListRepository.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 27/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

enum HeroListRepositoryError: Error {
    case unableToLoadHeroes
}

class HeroListRepository {
    let provider: MarvelService

    var currentPage = 0
    let limit = 20

    init(provider: MarvelService = MarvelServiceProvider()) {
        self.provider = provider
    }

    func fetchHeroes(result: @escaping (Result<[MarvelHero], Error>) -> Void) {
        let offset = currentPage * limit
        provider.fetchHeroes(offset: offset, limit: limit, nameStartsWith: nil) { requestResult in
            switch requestResult {
            case let .success(data):
                do {
                    let parsedResponse = try JSONDecoder().decode(MarvelResponse.self, from: data)
                    self.currentPage += 1
                    result(.success(parsedResponse.data.results))
                } catch {
                    result(.failure(HeroListRepositoryError.unableToLoadHeroes))
                }
            case let .failure(error):
                result(.failure(error))
            }
        }
    }

}

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
    var isRequestingHeroes = false

    private var currentHeroes: [MarvelHero] = []

    init(provider: MarvelService = MarvelServiceProvider()) {
        self.provider = provider
    }

    func fetchHeroes(result: @escaping (Result<[MarvelHero], Error>) -> Void) {
        guard !isRequestingHeroes else {
            return
        }
        let offset = currentPage * limit
        isRequestingHeroes = true
        provider.fetchHeroes(offset: offset, limit: limit, nameStartsWith: nil) { requestResult in
            self.isRequestingHeroes = false
            switch requestResult {
            case let .success(data):
                do {
                    let parsedResponse = try JSONDecoder().decode(MarvelResponse.self, from: data)
                    self.currentPage += 1
                    self.currentHeroes.append(contentsOf: parsedResponse.data.results)
                    result(.success(self.currentHeroes))
                } catch {
                    result(.failure(HeroListRepositoryError.unableToLoadHeroes))
                }
            case let .failure(error):
                result(.failure(error))
            }
        }
    }

    func searchForHero(name: String, result: @escaping (Result<[MarvelHero], Error>) -> Void) {
        provider.fetchHeroes(offset: 0, limit: limit, nameStartsWith: name) { requestResult in
            switch requestResult {
            case let .success(data):
                do {
                    let parsedResponse = try JSONDecoder().decode(MarvelResponse.self, from: data)
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

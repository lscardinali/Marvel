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
    private let marvelProvider: MarvelService
    private let favoriteProvider: FavoriteService
    private(set) var currentResults: [HeroCellViewModel] = []

    var currentPage = 0
    let limit = 20

    init(marvelProvider: MarvelService = MarvelServiceProvider(),
         favoriteProvider: FavoriteService = FavoriteServiceProvider()) {
        self.marvelProvider = marvelProvider
        self.favoriteProvider = favoriteProvider
    }

    func toggleFavoriteHeroAtIndex(_ index: Int) {
        let heroViewModel = currentResults[index]
        let newViewModel: HeroCellViewModel
        if favoriteProvider.isFavorited(id: heroViewModel.id) {
            favoriteProvider.unfavoriteHero(id: heroViewModel.id)
            newViewModel = HeroCellViewModel(id: heroViewModel.id,
                                             heroName: heroViewModel.heroName,
                                             heroThumbnail: heroViewModel.heroThumbnail,
                                             favorited: false)
        } else {
            favoriteProvider.favoriteHero(id: heroViewModel.id)
            newViewModel = HeroCellViewModel(id: heroViewModel.id,
                                             heroName: heroViewModel.heroName,
                                             heroThumbnail: heroViewModel.heroThumbnail,
                                             favorited: true)
        }
        currentResults[index] = newViewModel
    }

    func resetResults() {
        currentResults = []
        currentPage = 0
    }

    func fetchHeroes(nameStartsWith: String?, result: @escaping (Result<[HeroCellViewModel], Error>) -> Void) {
        let offset = currentPage * limit
        marvelProvider.fetchHeroes(offset: offset, limit: limit, nameStartsWith: nameStartsWith) { requestResult in
            switch requestResult {
            case let .success(data):
                do {
                    let parsedResponse = try JSONDecoder().decode(MarvelHeroResponse.self, from: data)
                    self.currentPage += 1
                    let viewModels = self.parseHeroesToViewModel(heroes: parsedResponse.data.results)
                    self.currentResults.append(contentsOf: viewModels)
                    result(.success(self.currentResults))
                } catch {
                    result(.failure(HeroListRepositoryError.unableToLoadHeroes))
                }
            case let .failure(error):
                result(.failure(error))
            }
        }
    }

    private func parseHeroesToViewModel(heroes: [MarvelHero]) -> [HeroCellViewModel] {
        return heroes.map({ hero in
            let thumbnail = "\(hero.thumbnail.path).\(hero.thumbnail.thumbnailExtension)"
            return HeroCellViewModel(id: hero.id,
                                     heroName: hero.name,
                                     heroThumbnail: thumbnail,
                                     favorited: favoriteProvider.isFavorited(id: hero.id))
        })
    }

}

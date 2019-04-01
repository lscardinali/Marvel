//
//  HeroRepository.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 31/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

final class HeroRepository {

    private let marvelProvider: MarvelService
    private let favoriteProvider: FavoriteService
    private var searchQuery: String = ""

    private let limit = 20
    var currentPage = 0
    var hasReachedEnd = false
    private var currentResults: [MarvelHero] = []

    init(marvelProvider: MarvelService = MarvelServiceProvider(),
         favoriteProvider: FavoriteService = FavoriteServiceProvider()) {
        self.marvelProvider = marvelProvider
        self.favoriteProvider = favoriteProvider
    }

    /// Resets the current results, used when starting a search or returning to list mode
    ///
    /// - Parameter newSearchQuery: Hero Name that should be searched
    func resetResults(newSearchQuery: String = "") {
        hasReachedEnd = false
        currentResults = []
        currentPage = 0
        searchQuery = newSearchQuery
    }

    /// Returns the current Heroes List in the form of ViewModels
    ///
    /// - Returns: ViewModels
    func currentViewModels() -> [HeroCellViewModel] {
        return parseHeroesToViewModel(heroes: currentResults)
    }

    /// Toggles a MarvelHero's favorite setting
    ///
    /// - Parameter index: Index of the hero in the Current Results
    func toggleFavoriteHeroAtIndex(_ index: Int) {
        let hero = currentResults[index]
        if favoriteProvider.isFavorited(id: hero.id) {
            favoriteProvider.unfavoriteHero(id: hero.id)
        } else {
            favoriteProvider.favoriteHero(id: hero.id)
        }
    }

    /// Fetches more heroes from the server, using the searchQuery if any.
    /// Pagination is controlled internally. This call always returns updated ViewModels
    ///
    /// - Parameter result: A Result closure that returns the updated ViewModels
    func fetchHeroes(result: @escaping (Result<[HeroCellViewModel], Error>) -> Void) {
        marvelProvider.fetchHeroes(offset: currentPage * limit,
                                   limit: limit,
                                   nameStartsWith: searchQuery) { requestResult in
            switch requestResult {
            case let .success(marvelResponse):
                do {
                    let parsedResults = try JSONDecoder().decode(MarvelHeroResponse.self, from: marvelResponse)
                    if parsedResults.data.results.isEmpty ||
                        parsedResults.data.results.count < self.limit {
                        self.hasReachedEnd = true
                    }
                    self.currentPage += 1
                    self.currentResults.append(contentsOf: parsedResults.data.results)
                    let viewModels = self.parseHeroesToViewModel(heroes: self.currentResults)
                    result(.success(viewModels))
                } catch {
                    result(.failure(error))
                }
            case let .failure(error):
                result(.failure(error))
            }
        }
    }

    /// Returns the Marvel Hero of an index of Current Results
    ///
    /// - Parameter index: index of Current Results
    /// - Returns: Marvel Hero
    func heroAt(index: Int) -> MarvelHero {
        return currentResults[index]
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

//
//  HeroDetailRepository.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 31/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

enum HeroDetailsType {
    case comics
    case stories
    case series
    case events
}

class HeroDetailRepository {

    let marvelHero: MarvelHero
    let marvelProvider: MarvelService
    let favoriteProvider: FavoriteService
    var currentViewModel: HeroDetailViewModel

    init(hero: MarvelHero, marvelProvider: MarvelService = MarvelServiceProvider(),
         favoriteProvider: FavoriteService = FavoriteServiceProvider()) {
        self.marvelHero = hero
        self.marvelProvider = marvelProvider
        self.favoriteProvider = favoriteProvider
        let thumbnail = "\(marvelHero.thumbnail.path).\(marvelHero.thumbnail.thumbnailExtension)"
        self.currentViewModel = HeroDetailViewModel(name: marvelHero.name, thumbnail: thumbnail,
                                                    favorited: favoriteProvider.isFavorited(id: marvelHero.id),
                                                    comics: [], series: [], events: [], stories: [])
    }

    /// Toggles a MarvelHero's favorite setting
    ///
    /// - Parameter index: Index of the hero in the Current Results
    func toggleFavoriteHero() {
        if favoriteProvider.isFavorited(id: marvelHero.id) {
            currentViewModel.favorited = false
            favoriteProvider.unfavoriteHero(id: marvelHero.id)
        } else {
            currentViewModel.favorited = true
            favoriteProvider.favoriteHero(id: marvelHero.id)
        }
    }

    func fetchHeroDetails(result: @escaping (Result<HeroDetailViewModel, Error>) -> Void) {
        let requestGroup = DispatchGroup()
        fetchComics(requestGroup: requestGroup) { requestResult in
            switch requestResult {
            case let .success(content):
                self.currentViewModel.comics = self.parseToViewModel(content: content)
            case let .failure(error):
                result(.failure(error))
            }
        }

        fetchStories(requestGroup: requestGroup) { requestResult in
            switch requestResult {
            case let .success(content):
                self.currentViewModel.stories = self.parseToViewModel(content: content)
            case let .failure(error):
                result(.failure(error))
            }
        }

        fetchEvents(requestGroup: requestGroup) { requestResult in
            switch requestResult {
            case let .success(content):
                self.currentViewModel.events = self.parseToViewModel(content: content)
            case let .failure(error):
                result(.failure(error))
            }
        }

        fetchSeries(requestGroup: requestGroup) { requestResult in
            switch requestResult {
            case let .success(content):
                self.currentViewModel.series = self.parseToViewModel(content: content)
            case let .failure(error):
                result(.failure(error))
            }
        }

        requestGroup.notify(queue: .main) {
            result(.success(self.currentViewModel))
        }
    }

    private func fetchComics(requestGroup: DispatchGroup, result: @escaping (Result<[MarvelContent], Error>) -> Void) {
        requestGroup.enter()
        marvelProvider.fetchComics(offset: 0, limit: 3, characterID: marvelHero.id) { requestResult in
            self.parseResult(requestGroup: requestGroup, requestResult: requestResult, result: result)
        }
    }

    private func fetchStories(requestGroup: DispatchGroup, result: @escaping (Result<[MarvelContent], Error>) -> Void) {
        requestGroup.enter()
        marvelProvider.fetchStories(offset: 0, limit: 3, characterID: marvelHero.id) { requestResult in
            self.parseResult(requestGroup: requestGroup, requestResult: requestResult, result: result)
        }
    }

    private func fetchEvents(requestGroup: DispatchGroup, result: @escaping (Result<[MarvelContent], Error>) -> Void) {
        requestGroup.enter()
        marvelProvider.fetchEvents(offset: 0, limit: 3, characterID: marvelHero.id) { requestResult in
            self.parseResult(requestGroup: requestGroup, requestResult: requestResult, result: result)
        }
    }

    private func fetchSeries(requestGroup: DispatchGroup, result: @escaping (Result<[MarvelContent], Error>) -> Void) {
        requestGroup.enter()
        marvelProvider.fetchSeries(offset: 0, limit: 3, characterID: marvelHero.id) { requestResult in
            self.parseResult(requestGroup: requestGroup, requestResult: requestResult, result: result)
        }
    }

    private func parseResult(requestGroup: DispatchGroup, requestResult: Result<Data, Error>,
                             result: @escaping (Result<[MarvelContent], Error>) -> Void) {
        switch requestResult {
        case let .success(data):
            do {
                let parsedContent = try JSONDecoder().decode(MarvelContentResponse.self, from: data)
                result(.success(parsedContent.data.results))
            } catch {
                result(.failure(error))
            }
        case let .failure(error):
            result(.failure(error))
        }
        requestGroup.leave()
    }


    func parseToViewModel(content: [MarvelContent]) -> [HeroDetailViewModelContent] {
        return content.map { content in
            var thumbnail: String? = nil
            if let thumb = content.thumbnail {
                thumbnail = "\(thumb.path).\(thumb.thumbnailExtension)"
            }
            return HeroDetailViewModelContent(thumbnail: thumbnail,
                                              title: content.title,
                                              description: content.description)
        }
    }

}

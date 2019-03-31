//
//  MarvelProviderStub.swift
//  MarvelTests
//
//  Created by Lucas Salton Cardinali on 31/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

@testable import Marvel

class MarvelProviderStub: MarvelService {

    let emptyStub: Bool

    init(emptyStub: Bool = false) {
        self.emptyStub = emptyStub
    }

    func fetchHeroes(offset: Int, limit: Int, nameStartsWith: String, result: @escaping (Result<Data, Error>) -> Void) {
        let path = Bundle(for: type(of: self)).path(forResource: emptyStub ? "empty" : "heroes", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        result(.success(data))
    }

    func fetchComics(offset: Int, limit: Int, characterID: Int, result: @escaping (Result<Data, Error>) -> Void) {
        let path = Bundle(for: type(of: self)).path(forResource: emptyStub ? "empty" : "comics", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        result(.success(data))
    }

    func fetchSeries(offset: Int, limit: Int, characterID: Int, result: @escaping (Result<Data, Error>) -> Void) {
        let path = Bundle(for: type(of: self)).path(forResource: emptyStub ? "empty" : "series", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        result(.success(data))
    }

    func fetchStories(offset: Int, limit: Int, characterID: Int, result: @escaping (Result<Data, Error>) -> Void) {
        let path = Bundle(for: type(of: self)).path(forResource: emptyStub ? "empty" : "stories", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        result(.success(data))
    }

    func fetchEvents(offset: Int, limit: Int, characterID: Int, result: @escaping (Result<Data, Error>) -> Void) {
        let path = Bundle(for: type(of: self)).path(forResource: emptyStub ? "empty" : "events", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        result(.success(data))
    }
}

class MarvelProviderFailureStub: MarvelService {

    func fetchHeroes(offset: Int, limit: Int, nameStartsWith: String, result: @escaping (Result<Data, Error>) -> Void) {
        result(.success(Data(count: 10)))
    }

    func fetchComics(offset: Int, limit: Int, characterID: Int, result: @escaping (Result<Data, Error>) -> Void) {
        result(.success(Data(count: 10)))
    }

    func fetchSeries(offset: Int, limit: Int, characterID: Int, result: @escaping (Result<Data, Error>) -> Void) {
        result(.success(Data(count: 10)))
    }

    func fetchStories(offset: Int, limit: Int, characterID: Int, result: @escaping (Result<Data, Error>) -> Void) {
        result(.success(Data(count: 10)))
    }

    func fetchEvents(offset: Int, limit: Int, characterID: Int, result: @escaping (Result<Data, Error>) -> Void) {
        result(.success(Data(count: 10)))
    }
}

class FavoriteProviderStub: FavoriteService {

    var favorited: [Int] = []

    func isFavorited(id: Int) -> Bool {
        return favorited.contains(id)
    }

    func favoriteHero(id: Int) {
        if !favorited.contains(id) {
            favorited.append(id)
        }
    }

    func unfavoriteHero(id: Int) {
        favorited.removeAll(where: { item in
            item == id
        })
    }
}

//
//  MarvelServiceProvider.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 26/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

enum MarvelServiceError: Error {
    case invalidUrl
    case malformedUrl
}

enum MarvelEndpoint {
    case characters(nameStartsWith: String, limit: Int, offset: Int)
    case comics(characterID: Int, limit: Int, offset: Int)
    case events(characterID: Int, limit: Int, offset: Int)
    case series(characterID: Int, limit: Int, offset: Int)
    case stories(characterID: Int, limit: Int, offset: Int)
}

extension MarvelEndpoint: EndpointType {
    var baseURL: URL {
        return URL(string: "https://gateway.marvel.com:443")!
    }

    var path: String {
        switch self {
        case .characters:
            return "/v1/public/characters"
        case .comics(let characterID, _, _):
            return "/v1/public/characters/\(characterID)/comics"
        case .events(let characterID, _, _):
            return "/v1/public/characters/\(characterID)/events"
        case .series(let characterID, _, _):
            return "/v1/public/characters/\(characterID)/series"
        case .stories(let characterID, _, _):
            return "/v1/public/characters/\(characterID)/stories"
        }
    }

    var parameters: [String: String] {
        switch self {
        case .characters(let nameStartsWith, let limit, let offset):
            var params = ["offset": String(offset), "limit": String(limit)]
            if !nameStartsWith.isEmpty {
                params["nameStartsWith"] = nameStartsWith
            }
            return params
        case .comics(_, let limit, let offset),
             .events(_, let limit, let offset),
             .series(_, let limit, let offset),
             .stories(_, let limit, let offset):
            return ["offset": String(offset), "limit": String(limit)]
        }
    }
}

struct MarvelServiceProvider {

    private func marvelRequest(_ request: MarvelEndpoint, result: @escaping (Result<Data, Error>) -> Void) {
        guard var urlComponents = URLComponents(url: request.baseURL, resolvingAgainstBaseURL: true) else {
            DispatchQueue.main.async {
                result(.failure(MarvelServiceError.invalidUrl))
            }
            return
        }

        urlComponents.path = request.path

        let timestamp = "\(Date().currentTimeMillis())"

        let apiKeyHash = "\(timestamp)\(Keys.Marvel.privateKey)\(Keys.Marvel.publicKey)".md5Value
        urlComponents.queryItems = [URLQueryItem(name: "apikey", value: Keys.Marvel.publicKey),
                                    URLQueryItem(name: "hash", value: apiKeyHash),
                                    URLQueryItem(name: "ts", value: timestamp)]

        urlComponents.queryItems?.append(contentsOf: request.parameters.map { param in
            return URLQueryItem(name: param.key, value: param.value)
        })

        guard let url = urlComponents.url else {
            DispatchQueue.main.async {
                result(.failure(MarvelServiceError.malformedUrl))
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    result(.failure(error))
                } else if let data = data {
                    result(.success(data))
                }
            }
            }.resume()
    }
}

extension MarvelServiceProvider: MarvelService {

    func fetchHeroes(offset: Int = 0, limit: Int, nameStartsWith: String,
                     result: @escaping (Result<Data, Error>) -> Void) {
        marvelRequest(.characters(nameStartsWith: nameStartsWith, limit: limit, offset: offset), result: result)
    }

    func fetchComics(offset: Int, limit: Int, characterID: Int,
                     result: @escaping (Result<Data, Error>) -> Void) {
         marvelRequest(.comics(characterID: characterID, limit: limit, offset: offset), result: result)
    }

    func fetchSeries(offset: Int, limit: Int, characterID: Int,
                     result: @escaping (Result<Data, Error>) -> Void) {
        marvelRequest(.series(characterID: characterID, limit: limit, offset: offset), result: result)
    }

    func fetchStories(offset: Int, limit: Int, characterID: Int,
                      result: @escaping (Result<Data, Error>) -> Void) {
        marvelRequest(.stories(characterID: characterID, limit: limit, offset: offset), result: result)
    }

    func fetchEvents(offset: Int, limit: Int, characterID: Int,
                     result: @escaping (Result<Data, Error>) -> Void) {
        marvelRequest(.events(characterID: characterID, limit: limit, offset: offset), result: result)
    }

}

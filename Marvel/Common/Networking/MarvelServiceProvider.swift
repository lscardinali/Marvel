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

struct MarvelRequest {
    let baseUrl = "https://gateway.marvel.com:443/v1/public"
    let path: String
    let params: [String: String]
    var url: String {
            return baseUrl + path
    }
    func apiKeyHash(timestamp: String) -> String {
        return "\(timestamp)\(Keys.Marvel.privateKey)\(Keys.Marvel.publicKey)".md5Value
    }
}

struct MarvelServiceProvider: MarvelService {

    private func marvelRequest(_ request: MarvelRequest, result: @escaping (Result<Data, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: request.url) else {
            return result(.failure(MarvelServiceError.invalidUrl))
        }

        let timestamp = "\(Date().currentTimeMillis())"

        let apiKeyHash = request.apiKeyHash(timestamp: timestamp)
        urlComponents.queryItems = [URLQueryItem(name: "apikey", value: Keys.Marvel.publicKey),
                                    URLQueryItem(name: "hash", value: apiKeyHash),
                                    URLQueryItem(name: "ts", value: timestamp)]

        urlComponents.queryItems?.append(contentsOf: request.params.map { param in
            return URLQueryItem(name: param.key, value: param.value)
        })

        guard let url = urlComponents.url else {
            result(.failure(MarvelServiceError.malformedUrl))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                result(.failure(error))
            } else if let data = data {
                result(.success(data))
            }
            }.resume()
    }

    func fetchHeroes(offset: Int? = 0,
                     limit: Int? = 20,
                     nameStartsWith: String? = nil,
                     result: @escaping (Result<Data, Error>) -> Void) {
        var params: [String: String] = [:]

        if let offset = offset {
            params["offset"] = "\(offset)"
        }

        if let limit = limit {
            params["limit"] = "\(limit)"
        }

        if let nameStartsWith = nameStartsWith {
            params["nameStartsWith"] = "\(nameStartsWith)"
        }

        let request = MarvelRequest(path: "/characters", params: params)
        marvelRequest(request, result: result)
    }

}

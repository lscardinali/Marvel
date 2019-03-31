//
//  MarvelHero.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 27/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

struct MarvelHeroResponse: Codable {
    let code: Int
    let data: MarvelHeroResponseData
}

struct MarvelHeroResponseData: Codable {
    let offset, limit, total, count: Int
    let results: [MarvelHero]
}

struct MarvelHero: Codable {
    let id: Int
    let name, description: String
    let thumbnail: Thumbnail
    let comics, series, stories, events: MarvelContentEntry
}

struct MarvelContentEntry: Codable {
    let items: [MarvelContentEntryItem]
}

struct MarvelContentEntryItem: Codable {
    let resourceURI: String
    let name: String
}

struct Thumbnail: Codable {
    let path, thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

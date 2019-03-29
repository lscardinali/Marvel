//
//  MarvelComic.swift
//  Marvel
//
//  Created by lucas.cardinali on 3/28/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

struct MarvelComicResponse: Codable {
    let code: Int
    let data: MarvelComicResponseData
}

struct MarvelComicResponseData: Codable {
    let offset, limit, total, count: Int
    let results: [MarvelComic]
}

struct MarvelComic: Codable {
    let title, description: String
    let thumbnail: Thumbnail
}


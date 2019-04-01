//
//  MarvelContent.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 30/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

struct MarvelContentResponse: Codable {
    let code: Int
    let data: MarvelContentResponseData
}

struct MarvelContentResponseData: Codable {
    let offset, limit, total, count: Int
    let results: [MarvelContent]
}

struct MarvelContent: Codable {
    let title: String
    let description: String?
    let thumbnail: Thumbnail?
}

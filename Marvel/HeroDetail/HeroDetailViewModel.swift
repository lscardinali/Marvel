//
//  HeroDetailsViewModel.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 30/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import Foundation

struct HeroDetailViewModel {
    let name: String
    let thumbnail: String
    var favorited: Bool
    var comics: [HeroDetailViewModelContent]
    var series: [HeroDetailViewModelContent]
    var events: [HeroDetailViewModelContent]
    var stories: [HeroDetailViewModelContent]
}

struct HeroDetailViewModelContent {
    let thumbnail: String?
    let title: String
    let description: String?
}

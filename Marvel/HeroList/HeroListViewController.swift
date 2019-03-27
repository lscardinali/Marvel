//
//  HeroListViewController.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 26/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

final class HeroListViewController: UIViewController {

    let heroListView = HeroListView()

    let repository: HeroListRepository

    init(repository: HeroListRepository = HeroListRepository()) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
        heroListView.delegate = self
        title = "Heroes"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = heroListView
    }

    override func viewDidLoad() {
        heroListView.setState(state: .loadingData)
        repository.fetchHeroes { result in
            switch result {
            case let .success(heroes):
                let viewModels: [HeroCellViewModel] = heroes.map({ hero in
                    let thumbnail = "\(hero.thumbnail.path).\(hero.thumbnail.thumbnailExtension)"
                    return HeroCellViewModel(heroName: hero.name, heroThumbnail: thumbnail, favorited: false)
                })
                  DispatchQueue.main.async {
                self.heroListView.setState(state: .dataLoaded(viewModels))
                }
            case .failure(let error):
                self.heroListView.setState(state: .errorOnLoad)
            }
        }
    }
    
}

extension HeroListViewController: HeroListViewDelegate {
    func didSelectItemAtIndex(index: Int) {

    }

}

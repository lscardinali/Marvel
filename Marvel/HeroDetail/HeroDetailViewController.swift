//
//  HeroDetailViewController.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 28/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

final class HeroDetailViewController: UIViewController {

    let heroDetailView: HeroDetailView
    let repository: HeroDetailRepository

    override func loadView() {
        self.view = heroDetailView
    }

    init(repository: HeroDetailRepository, view: HeroDetailView = HeroDetailView()) {
        self.repository = repository
        self.heroDetailView = view
        super.init(nibName: nil, bundle: nil)
        heroDetailView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        heroDetailView.setState(.loadingData)
        repository.fetchHeroDetails { result in
            switch result {
            case let .success(newViewModel):
                self.heroDetailView.setState(.dataLoaded(newViewModel))
            case .failure:
                self.heroDetailView.setState(.errorOnLoad("Couldn't load hero details :("))
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeroDetailViewController: HeroDetailViewDelegate {
    func didTapFavoriteHero() {
        repository.toggleFavoriteHero()
        heroDetailView.setState(.dataLoaded(repository.currentViewModel))
    }

    func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

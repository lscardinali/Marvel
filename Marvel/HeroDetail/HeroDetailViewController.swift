//
//  HeroDetailViewController.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 28/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

final class HeroDetailViewController: UIViewController {

    let heroDetailView = HeroDetailView()
    let repository: HeroDetailRepository

    override func loadView() {
        self.view = heroDetailView
    }

    init(repository: HeroDetailRepository) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavoriteButton()
        self.title = repository.currentViewModel.name
        heroDetailView.setState(.dataLoaded(repository.currentViewModel))
        fetchHeroDetails()
    }

    func fetchHeroDetails() {
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

    private func setupFavoriteButton() {
        let favoriteButton = UIBarButtonItem(image: repository.currentViewModel.favorited ? #imageLiteral(resourceName: "Favorited") : #imageLiteral(resourceName: "Unfavorited"), style: .plain,
                                             target: self, action: #selector(didTapFavoriteHero))
        favoriteButton.accessibilityIdentifier = repository.currentViewModel.favorited ?
            "FavoritedButton" : "UnfavoritedButton"
        navigationItem.setRightBarButton(favoriteButton, animated: true)
    }

    @objc private func didTapFavoriteHero() {
        repository.toggleFavoriteHero()
        setupFavoriteButton()
    }
}

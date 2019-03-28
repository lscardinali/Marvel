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

    let transition = PopAnimator()

    let heroSearchController = UISearchController(searchResultsController: nil)

    var searchingForHero = false

    init(repository: HeroListRepository = HeroListRepository()) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
        heroListView.delegate = self
        heroSearchController.searchResultsUpdater = self
        heroSearchController.obscuresBackgroundDuringPresentation = false
        heroSearchController.searchBar.placeholder = "Search hero by name"
        navigationItem.searchController = heroSearchController
        definesPresentationContext = true
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
        fetchHeroes()
    }

    func fetchHeroes() {
        repository.fetchHeroes { result in
            self.processResult(result)
        }
    }

    func searchForHero(name: String) {
        self.heroListView.setState(state: .loadingData)
        repository.searchForHero(name: name) { result in
            self.processResult(result)
        }
    }

    func processResult(_ result: Result<[MarvelHero], Error>) {
        switch result {
        case let .success(heroes):
            let viewModels = self.parseHeroesToViewModel(heroes: heroes)
            self.heroListView.setState(state: .dataLoaded(viewModels))
        case .failure:
            self.heroListView.setState(state: .errorOnLoad)
        }
    }

    func parseHeroesToViewModel(heroes: [MarvelHero]) -> [HeroCellViewModel] {
        return heroes.map({ hero in
            let thumbnail = "\(hero.thumbnail.path).\(hero.thumbnail.thumbnailExtension)"
            return HeroCellViewModel(heroName: hero.name, heroThumbnail: thumbnail, favorited: false)
        })
    }

}

extension HeroListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let heroName = searchController.searchBar.text, heroName.count > 3 {
            searchForHero(name: heroName)
        }
    }
}

extension HeroListViewController: HeroListViewDelegate {

    func isReachingEndOfList() {
        if !searchingForHero {
            fetchHeroes()
        }
    }

    func didSelectItemAtIndex(index: Int) {
        let detail = HeroDetailViewController()
        detail.transitioningDelegate = self
        present(detail, animated: true, completion: nil)
    }

}

extension HeroListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.originFrame = self.heroListView.tableView.superview!.convert(heroListView.tableView.frame, to: nil)
//        transition.presenting = true
//        heroListView.tableView.isHidden = true
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

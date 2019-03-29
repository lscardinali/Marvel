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

    var searchQuery: String?

    init(repository: HeroListRepository = HeroListRepository()) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
        heroListView.delegate = self
        heroSearchController.searchBar.delegate = self
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
        repository.fetchHeroes(nameStartsWith: searchQuery) { result in
            switch result {
            case let .success(heroes):
                self.heroListView.setState(state: .dataLoaded(heroes))
            case .failure:
                self.heroListView.setState(state: .errorOnLoad)
            }
        }
    }
}

extension HeroListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let heroName = searchController.searchBar.text, heroName.count > 3 {
            self.searchQuery = heroName
            self.heroListView.setState(state: .loadingData)
            self.repository.resetResults()
            fetchHeroes()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         searchQuery = nil
        self.heroListView.setState(state: .loadingData)
        self.repository.resetResults()
        fetchHeroes()
    }

}

extension HeroListViewController: HeroListViewDelegate {
    func didFavouriteItemAtIndex(_ index: Int) {
        repository.toggleFavoriteHeroAtIndex(index)
        heroListView.setState(state: .dataLoaded(repository.currentResults))
    }

    func isReachingEndOfList() {
        fetchHeroes()
    }

    func didSelectItemAtIndex(index: Int) {
        let detail = HeroDetailViewController()

//        navigationController?.pushViewController(detail, animated: true)
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
//        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

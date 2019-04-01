//
//  HeroListViewController.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 26/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

final class HeroListViewController: UIViewController {

    private let repository: HeroRepository
    private let heroListView: HeroListView
    let heroSearchController = UISearchController(searchResultsController: nil)

    var selectedIndex: Int = 0

    // MARK: Initialization
    init(repository: HeroRepository = HeroRepository(), view: HeroListView = HeroListView()) {
        self.repository = repository
        self.heroListView = view
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = heroListView
    }

    private func commonInit() {
        heroListView.delegate = self
        heroSearchController.searchBar.delegate = self
        heroSearchController.obscuresBackgroundDuringPresentation = false
        heroSearchController.searchBar.placeholder = "Search hero by name"
        navigationItem.searchController = heroSearchController
        definesPresentationContext = true
        title = "Marvel Heroes"
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        self.navigationController?.delegate = self
        fetchHeroes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !repository.currentViewModels().isEmpty {
            heroListView.setState(state: .dataLoaded(repository.currentViewModels()))
        }
    }

    func fetchHeroes() {
        heroListView.setState(state: (repository.currentPage == 0) ? .loadingData : .loadingMoreData)
        repository.fetchHeroes { result in
            switch result {
            case let .success(updatedViewModels):
                let currentViewModels = self.repository.currentViewModels()
                if currentViewModels.isEmpty && updatedViewModels.isEmpty {
                    self.heroListView.setState(state: .errorOnLoad("Couldnt find any hero :("))
                } else {
                    self.heroListView.setState(state: .dataLoaded(updatedViewModels))
                }
            case .failure:
                self.heroListView.setState(state: .errorOnLoad("There was a problem loading the heroes"))
            }
        }
    }
}

extension HeroListViewController: UISearchBarDelegate {

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let heroName = searchBar.text, heroName.count > 3 {
            repository.resetResults(newSearchQuery: heroName)
            fetchHeroes()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        repository.resetResults()
        fetchHeroes()
    }

}

extension HeroListViewController: HeroListViewDelegate {
    func didFavouriteItemAtIndex(_ index: Int) {
        repository.toggleFavoriteHeroAtIndex(index)
        heroListView.setState(state: .dataLoaded(repository.currentViewModels()))
    }

    func isReachingEndOfList() {
        if !repository.hasReachedEnd {
            fetchHeroes()
        }
    }

    func didSelectItemAtIndex(index: Int) {
        let hero = repository.heroAt(index: index)
        selectedIndex = index
        let detail = HeroDetailViewController(repository: HeroDetailRepository(hero: hero))
        navigationController?.pushViewController(detail, animated: true)
    }
}

extension HeroListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let cellRect = self.heroListView.tableView.rectForRow(at: IndexPath(row: selectedIndex, section: 0))
        let frame = self.heroListView.tableView.convert(cellRect, to: self.heroListView)
        return CellExpanderAnimator(originLocation: frame, presenting: operation == .push ? true : false)
    }
}

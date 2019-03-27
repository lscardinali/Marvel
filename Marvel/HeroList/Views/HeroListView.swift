//
//  HeroListView.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 26/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

enum HeroListViewState {
    case loadingData
    case dataLoaded([HeroCellViewModel])
    case errorOnLoad
}

protocol HeroListViewDelegate: class {
    func didSelectItemAtIndex(index: Int)
}

final class HeroListView: UIView {

    weak var delegate: HeroListViewDelegate?

    let tableViewManager: HeroListTableViewManager

    init() {
        self.tableViewManager = HeroListTableViewManager(tableview: tableView)
        super.init(frame: .zero)
        setupView()
        self.tableViewManager.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)

    let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.text = "Couldn't load heroes"
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for the name of your favourite Marvel hero..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
}

extension HeroListView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(activityIndicator)
        addSubview(statusLabel)
        addSubview(tableView)
        addSubview(searchBar)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),

            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),

            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor)
            ])
    }
}

extension HeroListView: HeroListTableViewManagerDelegate {
    func didSelectedItemAtIndex(_ index: Int) {
        delegate?.didSelectItemAtIndex(index: index)
    }
}

extension HeroListView {
    func setState(state: HeroListViewState) {
        switch state {
        case .loadingData:
            tableView.isHidden = true
            activityIndicator.isHidden = false
            statusLabel.isHidden = true
        case .dataLoaded(let viewModels):
            tableView.isHidden = false
            statusLabel.isHidden = true
            activityIndicator.isHidden = true
            tableViewManager.updateData(viewModels)
        case .errorOnLoad:
            tableView.isHidden = true
            statusLabel.isHidden = false
            activityIndicator.isHidden = true
        }
    }
}

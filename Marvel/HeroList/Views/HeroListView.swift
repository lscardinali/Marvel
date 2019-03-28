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
    func isReachingEndOfList()
}

final class HeroListView: UIView {

    weak var delegate: HeroListViewDelegate?

    let tableViewManager: HeroListTableViewManager

    init() {
        self.tableViewManager = HeroListTableViewManager(tableview: tableView)
        super.init(frame: .zero)
        setupView()
        tableViewManager.delegate = self
        backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    let tableViewActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.text = "Couldn't load heroes"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

}

extension HeroListView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(tableView)
        addSubview(activityIndicator)
        addSubview(statusLabel)
        tableView.tableFooterView = tableViewActivityIndicator
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),

            tableViewActivityIndicator.heightAnchor.constraint(equalToConstant: 55),
            tableViewActivityIndicator.widthAnchor.constraint(equalTo: tableView.widthAnchor),

            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor)
            ])
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

extension HeroListView: HeroListTableViewManagerDelegate {
    func isReachingEndOfList() {
        delegate?.isReachingEndOfList()
    }

    func didSelectedItemAtIndex(_ index: Int) {
        delegate?.didSelectItemAtIndex(index: index)
    }
}

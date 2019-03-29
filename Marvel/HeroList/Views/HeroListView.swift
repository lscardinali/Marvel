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
    func didFavouriteItemAtIndex(_ index: Int)
    func isReachingEndOfList()
}

final class HeroListView: UIView {

    weak var delegate: HeroListViewDelegate?
    var data: [HeroCellViewModel] = []

    init() {
        super.init(frame: .zero)
        setupView()
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        backgroundColor = UIColor.white
    }

    func registerCells() {
        tableView.register(cellType: HeroTableViewCell.self)
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
            data = viewModels
            tableView.reloadData()
        case .errorOnLoad:
            tableView.isHidden = true
            statusLabel.isHidden = false
            activityIndicator.isHidden = true
        }
    }
}

extension HeroListView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HeroTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setupCell(data[indexPath.row])
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItemAtIndex(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count-1 {
            delegate?.isReachingEndOfList()
        }
    }
}

extension HeroListView: HeroTableViewCellDelegate {
    func didTapFavoriteButton(_ sender: HeroTableViewCell) {
        guard let index = tableView.indexPath(for: sender)?.row else {
            return
        }
        delegate?.didFavouriteItemAtIndex(index)
        tableView.reloadData()
    }
}

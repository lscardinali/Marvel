//
//  HeroDetailView.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 28/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

enum HeroDetailViewSections: Int {
    case header
    case comics
    case events
    case stories
    case series
}

protocol HeroDetailViewDelegate: class {
    func didTapCloseButton()
    func didTapFavoriteHero()
}

enum HeroDetailViewState {
    case loadingData
    case dataLoaded(HeroDetailViewModel)
    case errorOnLoad(String)
}

final class HeroDetailView: UIView {

    private let sections = 5
    weak var delegate: HeroDetailViewDelegate?
    var viewModel: HeroDetailViewModel?

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let loadingHUD = LoadingHUD()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
        button.alpha = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func registerCells() {
        tableView.register(cellType: HeroDetailHeaderCell.self)
        tableView.register(cellType: HeroDetailContentCell.self)
    }

    @objc private func didTapCloseButton() {
        delegate?.didTapCloseButton()
    }
}

extension HeroDetailView: ViewConfiguration {

    internal func setupView() {
        buildViewHierarchy()
        setupConstraints()
        registerCells()
        tableView.alpha = 0
        tableView.delegate = self
        tableView.dataSource = self
        backgroundColor = UIColor.white
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchDown)
    }

    internal func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),

            loadingHUD.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingHUD.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    internal func buildViewHierarchy() {
        addSubview(tableView)
        addSubview(loadingHUD)
        addSubview(closeButton)
        addSubview(statusLabel)
        bringSubviewToFront(loadingHUD)
    }
}

extension HeroDetailView {
    func setState(_ state: HeroDetailViewState) {
        switch state {
        case let .errorOnLoad(error):
            loadingHUD.isHidden = true
            tableView.isHidden = true
            statusLabel.isHidden = false
            statusLabel.text = error
        case .loadingData:
            tableView.isHidden = true
            loadingHUD.isHidden = false
            statusLabel.isHidden = true
        case let .dataLoaded(viewModel):
            self.viewModel = viewModel
            tableView.isHidden = false
            tableView.reloadData()
            loadingHUD.isHidden = true
            statusLabel.isHidden = true
            UIView.animate(withDuration: 0.5) {
                self.tableView.alpha = 1
            }
        }
    }
}

extension HeroDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = HeroDetailViewSections(rawValue: section), let viewModel = viewModel else { return 0 }
        switch section {
        case .header: return 1
        case .comics: return viewModel.comics.count
        case .events: return viewModel.events.count
        case .series: return viewModel.series.count
        case .stories: return viewModel.stories.count
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = HeroDetailViewSections(rawValue: section), let viewModel = viewModel else { return nil }
        switch section {
        case .comics: return viewModel.comics.isEmpty ? nil : "Comics"
        case .events: return viewModel.events.isEmpty ? nil : "Events"
        case .series: return viewModel.series.isEmpty ? nil : "Series"
        case .stories: return viewModel.stories.isEmpty ? nil : "Stories"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = HeroDetailViewSections(rawValue: indexPath.section), let viewModel = viewModel else {
            return UITableViewCell()
        }
        switch section {
        case .header:
            let cell: HeroDetailHeaderCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setupCell(from: viewModel)
            cell.delegate = self
            return cell
        case .comics:
            let cell: HeroDetailContentCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setupCell(content: viewModel.comics[indexPath.row])
            return cell
        case .stories:
            let cell: HeroDetailContentCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setupCell(content: viewModel.stories[indexPath.row])
            return cell
        case .series:
            let cell: HeroDetailContentCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setupCell(content: viewModel.series[indexPath.row])
            return cell
        case .events:
            let cell: HeroDetailContentCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setupCell(content: viewModel.events[indexPath.row])
            return cell
        }
    }
}

extension HeroDetailView: HeroDetailHeaderCellDelegate {
    func didTapFavoriteButton(_ sender: HeroDetailHeaderCell) {
        delegate?.didTapFavoriteHero()
    }
}

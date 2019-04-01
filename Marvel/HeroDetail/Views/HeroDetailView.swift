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

    let loadingHUD = LoadingHUD()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func registerCells() {
        tableView.register(cellType: HeroDetailHeaderCell.self)
        tableView.register(cellType: HeroDetailContentCell.self)
    }

    private func viewModelForSection(_ section: HeroDetailViewSections) -> [HeroDetailViewModelContent]? {
        switch section {
        case .comics: return viewModel?.comics
        case .events: return viewModel?.events
        case .series: return viewModel?.series
        case .stories: return viewModel?.stories
        default: return nil
        }
    }
}

extension HeroDetailView: ViewConfiguration {

    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        backgroundColor = UIColor.white
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            loadingHUD.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingHUD.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    func buildViewHierarchy() {
        addSubview(tableView)
        addSubview(loadingHUD)
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
            tableView.isHidden = false
            loadingHUD.isHidden = false
            statusLabel.isHidden = true
        case let .dataLoaded(viewModel):
            self.viewModel = viewModel
            tableView.isHidden = false
            tableView.reloadData()
            loadingHUD.isHidden = true
            statusLabel.isHidden = true
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
            fatalError("Wrong section provided")
        }
        switch section {
        case .header:
            let cell: HeroDetailHeaderCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setupCell(from: viewModel)
            return cell
        case .comics, .stories, .series, .events:
            guard let sectionViewModel = viewModelForSection(section) else { fatalError("Content ViewModel not found") }
            let cell: HeroDetailContentCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setupCell(content: sectionViewModel[indexPath.row])
            return cell
        }
    }
}

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
}

final class HeroDetailView: UIView {

    private let sections = 5
    weak var delegate: HeroDetailViewDelegate?

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init() {
        super.init(frame: .zero)
        setupView()
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func registerCells() {
        tableView.register(cellType: HeroDetailHeaderCell.self)
        tableView.register(cellType: HeroDetailContentCell.self)
    }
}

extension HeroDetailView: ViewConfiguration {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 64),
            closeButton.heightAnchor.constraint(equalToConstant: 64),
            ])
    }

    func buildViewHierarchy() {
        addSubview(tableView)
        addSubview(closeButton)
    }
}

extension HeroDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = HeroDetailViewSections(rawValue: section) else {
            return 0
        }
        switch section {
        case .header: return 1
        default: return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = HeroDetailViewSections(rawValue: section) else {
            return nil
        }
        switch section {
        case .comics: return "Comics"
        case .events: return "Events"
        case .series: return "Series"
        case .stories: return "Stories"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = HeroDetailViewSections(rawValue: indexPath.section) else {
            //TODO: Remove this
            return UITableViewCell()
        }
        switch section {
        case .header:
            let cell: HeroDetailHeaderCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setupCell()
            return cell
        default:
            let cell: HeroDetailContentCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }

//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
}

//
//  HeroDetailHeaderCell.swift
//  Marvel
//
//  Created by lucas.cardinali on 3/28/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

final class HeroDetailHeaderCell: UITableViewCell, Reusable {

    let heroThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(from viewModel: HeroDetailViewModel) {
        heroThumbnail.from(urlString: viewModel.thumbnail, placeholder: #imageLiteral(resourceName: "Avatar"))
    }
}

extension HeroDetailHeaderCell: ViewConfiguration {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            heroThumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroThumbnail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroThumbnail.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroThumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

            ])
        let heightConstraint = heroThumbnail.heightAnchor.constraint(equalTo: heroThumbnail.widthAnchor)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.isActive = true
    }

    func buildViewHierarchy() {
        contentView.addSubview(heroThumbnail)
    }

    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        accessibilityIdentifier = "HeroDetailHeaderCell"
        selectionStyle = .none
    }
}

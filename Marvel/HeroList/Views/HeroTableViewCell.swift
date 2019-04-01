//
//  HeroTableViewCell.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 26/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

protocol HeroTableViewCellDelegate: class {
    func didTapFavoriteButton(_ sender: HeroTableViewCell)
}

final class HeroTableViewCell: UITableViewCell, Reusable {

    weak var delegate: HeroTableViewCellDelegate?

    // MARK: Views
    let heroThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Avatar")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let heroNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let favoriteButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "FavoriteButton"
        button.setTitleColor(UIColor.red, for: .normal)
        button.tintColor = UIColor.red
        button.setImage(#imageLiteral(resourceName: "Unfavorited"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "Favorited"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(_ model: HeroCellViewModel) {
        heroNameLabel.text = model.heroName
        heroThumbnail.from(urlString: model.heroThumbnail, placeholder: #imageLiteral(resourceName: "Avatar"))
        favoriteButton.isSelected = model.favorited
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchDown)
    }

    @objc private func didTapFavoriteButton() {
        delegate?.didTapFavoriteButton(self)
    }
}

extension HeroTableViewCell: ViewConfiguration {

    func setupView() {
        accessibilityIdentifier = "HeroTableViewCell"
        buildViewHierarchy()
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            heroThumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            heroThumbnail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            heroThumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            heroThumbnail.widthAnchor.constraint(equalToConstant: 42),

            heroThumbnail.trailingAnchor.constraint(equalTo: heroNameLabel.leadingAnchor, constant: -16),

            heroNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heroNameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -16),

            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 64)
            ])
        let heightConstraint = heroThumbnail.heightAnchor.constraint(equalToConstant: 42)
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        heightConstraint.isActive = true
    }

    func buildViewHierarchy() {
        contentView.addSubview(heroThumbnail)
        contentView.addSubview(heroNameLabel)
        contentView.addSubview(favoriteButton)
    }
}

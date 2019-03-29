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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        button.setTitleColor(UIColor.red, for: .normal)
        button.tintColor = UIColor.red
        button.setImage(#imageLiteral(resourceName: "Unfavorited"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "Favorited"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    func setupCell(_ model: HeroCellViewModel) {
        heroNameLabel.text = model.heroName
        heroThumbnail.imageFromURL(urlString: model.heroThumbnail)
        favoriteButton.isSelected = model.favorited
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchDown)
    }

    @objc private func didTapFavoriteButton() {
        delegate?.didTapFavoriteButton(self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        heroThumbnail.image = #imageLiteral(resourceName: "Avatar")
    }

}

extension HeroTableViewCell: ViewConfiguration {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            heroThumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            heroThumbnail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            heroThumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            heroThumbnail.heightAnchor.constraint(equalToConstant: 42),
            heroThumbnail.widthAnchor.constraint(equalToConstant: 42),

            heroThumbnail.trailingAnchor.constraint(equalTo: heroNameLabel.leadingAnchor, constant: -16),

            heroNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heroNameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -16),

            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.heightAnchor.constraint(equalToConstant: 42),
            favoriteButton.widthAnchor.constraint(equalToConstant: 42)
            ])
    }

    func buildViewHierarchy() {
        contentView.addSubview(heroThumbnail)
        contentView.addSubview(heroNameLabel)
        contentView.addSubview(favoriteButton)
    }
}

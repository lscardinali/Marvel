//
//  HeroDetailHeaderCell.swift
//  Marvel
//
//  Created by lucas.cardinali on 3/28/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

protocol HeroDetailHeaderCellDelegate: class {
    func didTapFavoriteButton(_ sender: HeroDetailHeaderCell)
}

final class HeroDetailHeaderCell: UITableViewCell, Reusable {

    weak var delegate: HeroDetailHeaderCellDelegate?

    private let heroThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.red, for: .normal)
        button.tintColor = UIColor.red
        button.setImage(#imageLiteral(resourceName: "Unfavorited"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "Favorited"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let heroNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let informationView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(from viewModel: HeroDetailViewModel) {
        heroNameLabel.text = viewModel.name
        heroThumbnail.from(urlString: viewModel.thumbnail, placeholder: #imageLiteral(resourceName: "Avatar"))
        favoriteButton.isSelected = viewModel.favorited
    }

    @objc private func didTapFavoriteButton() {
        delegate?.didTapFavoriteButton(self)
    }
}

extension HeroDetailHeaderCell: ViewConfiguration {
    internal func setupConstraints() {
        NSLayoutConstraint.activate([
            heroThumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroThumbnail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroThumbnail.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroThumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            heroThumbnail.heightAnchor.constraint(equalTo: heroThumbnail.widthAnchor),

            informationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            informationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            informationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            informationView.heightAnchor.constraint(equalToConstant: 60),

            heroNameLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 16),
            heroNameLabel.bottomAnchor.constraint(equalTo: informationView.bottomAnchor, constant: -16),
            heroNameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -16),
            heroNameLabel.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 16),

            favoriteButton.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -16),
            favoriteButton.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 16),
            favoriteButton.leadingAnchor.constraint(equalTo: heroNameLabel.trailingAnchor, constant: 16),
            favoriteButton.bottomAnchor.constraint(equalTo: informationView.bottomAnchor, constant: -16)
            ])
    }

    internal func buildViewHierarchy() {
        contentView.addSubview(heroThumbnail)
        informationView.contentView.addSubview(heroNameLabel)
        informationView.contentView.addSubview(favoriteButton)
        contentView.addSubview(informationView)
    }

    internal func setupView() {
        buildViewHierarchy()
        setupConstraints()
        selectionStyle = .none
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchDown)
    }
}

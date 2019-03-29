//
//  HeroDetailContentCell.swift
//  Marvel
//
//  Created by lucas.cardinali on 3/29/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

final class HeroDetailContentCell: UITableViewCell, Reusable {

    var contentThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleToFill
        return imageView
    }()

    var contentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "TITLE"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var contentDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "LONG DESCRIPTION"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

extension HeroDetailContentCell: ViewConfiguration {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentThumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentThumbnail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentThumbnail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            contentThumbnail.heightAnchor.constraint(equalToConstant: 150),
            contentThumbnail.widthAnchor.constraint(equalToConstant: 100),

            contentTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentTitleLabel.leadingAnchor.constraint(equalTo: contentThumbnail.trailingAnchor, constant: 16),
            contentTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            contentTitleLabel.bottomAnchor.constraint(equalTo: contentDescriptionLabel.topAnchor, constant: 16),
            contentTitleLabel.heightAnchor.constraint(equalToConstant: 36),
//
            contentDescriptionLabel.topAnchor.constraint(equalTo: contentTitleLabel.bottomAnchor, constant: 16),
            contentDescriptionLabel.leadingAnchor.constraint(equalTo: contentThumbnail.trailingAnchor, constant: 16),
            contentDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            ])
    }

    func buildViewHierarchy() {
        contentView.addSubview(contentThumbnail)
        contentView.addSubview(contentTitleLabel)
        contentView.addSubview(contentDescriptionLabel)
    }
}

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
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    var contentTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()

    var contentDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(content: HeroDetailViewModelContent) {
        contentTitleLabel.text = content.title
        if let thumbnail = content.thumbnail {
            contentThumbnail.from(urlString: thumbnail, placeholder: #imageLiteral(resourceName: "Avatar"))
        }
        if let description = content.description, !description.isEmpty {
            contentDescriptionLabel.text = description
        } else {
            contentDescriptionLabel.text = "No Description Available"
        }
    }
}

extension HeroDetailContentCell: ViewConfiguration {

    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        selectionStyle = .none
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentThumbnail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentThumbnail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentThumbnail.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            contentThumbnail.heightAnchor.constraint(equalToConstant: 150),
            contentThumbnail.widthAnchor.constraint(equalToConstant: 100),

            contentTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentTitleLabel.leadingAnchor.constraint(equalTo: contentThumbnail.trailingAnchor, constant: 16),
            contentTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28),

            contentDescriptionLabel.topAnchor.constraint(equalTo: contentTitleLabel.bottomAnchor, constant: 4),
            contentDescriptionLabel.leadingAnchor.constraint(equalTo: contentThumbnail.trailingAnchor, constant: 16),
            contentDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
            ])
    }

    func buildViewHierarchy() {
        contentView.addSubview(contentThumbnail)
        contentView.addSubview(contentTitleLabel)
        contentView.addSubview(contentDescriptionLabel)
    }
}

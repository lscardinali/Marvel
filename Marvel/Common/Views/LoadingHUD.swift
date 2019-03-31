//
//  View.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 30/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

class LoadingHUD: UIVisualEffectView {

    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    init() {
        let effect = UIBlurEffect(style: .prominent)
        super.init(effect: effect)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LoadingHUD: ViewConfiguration {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heightAnchor.constraint(equalToConstant: 64),
            widthAnchor.constraint(equalToConstant: 64)
        ])
    }

    func buildViewHierarchy() {
        contentView.addSubview(activityIndicator)
    }

    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        layer.cornerRadius = 8
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}

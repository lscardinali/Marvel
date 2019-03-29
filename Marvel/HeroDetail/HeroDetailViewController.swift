//
//  HeroDetailViewController.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 28/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

final class HeroDetailViewController: UIViewController {

    let heroDetailView = HeroDetailView()

    override func loadView() {
        self.view = heroDetailView
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        heroDetailView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeroDetailViewController: HeroDetailViewDelegate {
    func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

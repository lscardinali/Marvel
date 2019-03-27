//
//  HeroListTableViewManager.swift
//  Marvel
//
//  Created by Lucas Salton Cardinali on 27/03/19.
//  Copyright © 2019 Lucas Salton Cardinali. All rights reserved.
//

import UIKit

protocol HeroListTableViewManagerDelegate: class {
    func didSelectedItemAtIndex(_ index: Int)
}

final class HeroListTableViewManager: NSObject, UITableViewDelegate, UITableViewDataSource {

    let tableview: UITableView

    weak var delegate: HeroListTableViewManagerDelegate?

    var data: [HeroCellViewModel] = []

    init(tableview: UITableView) {
        self.tableview = tableview
        super.init()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        registerCells()
    }

    private func registerCells() {
        tableview.register(cellType: HeroTableViewCell.self)
    }

    func updateData(_ newData: [HeroCellViewModel]) {
        data.append(contentsOf: newData)
        tableview.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HeroTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let model = data[indexPath.row]
        cell.setupCell(model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectedItemAtIndex(indexPath.row)
    }

}

//
//  ShareSelectViewController.swift
//  WishlistShareExtension
//
//  Created by fyz on 7/3/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//

import Foundation
import UIKit
protocol ShareSelectViewControllerDelegate: class {
    func selected(list: String)
}
class ShareSelectViewController: UIViewController {
    
    var lists = [String]()
    weak var delegate: ShareSelectViewControllerDelegate?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self as UITableViewDataSource
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.ListCell)
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        title = "Select List"
        view.addSubview(tableView)
    }
    
}

extension ShareSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ListCell, for: indexPath)
        cell.textLabel?.text = lists[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
}
extension ShareSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selected(list: lists[indexPath.row])
    }
}
private extension ShareSelectViewController {
    struct Identifiers {
        static let ListCell = "listCell"
    }
}


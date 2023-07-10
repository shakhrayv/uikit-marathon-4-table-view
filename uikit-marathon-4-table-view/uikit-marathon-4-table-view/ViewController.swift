//
//  ViewController.swift
//  uikit-marathon-4-table-view
//
//  Created by Vladislav Shakhray on 10/07/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    private var dataSource: UITableViewDiffableDataSource<Int, Int>!
    private var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
    
    private var identifiers = [Int]()
    private var selectedIdentifiers = Set<Int>()
    
    private func updateSnapshot(reconfigure: [Int]? = nil) {
        snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems(identifiers)
        if let reconfigure = reconfigure {
            snapshot.reconfigureItems(reconfigure)
        }
    
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        dataSource = .init(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            guard let self = self, let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") else { return .init() }
            
            cell.textLabel?.text = String(itemIdentifier)
            if self.selectedIdentifiers.contains(itemIdentifier) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }

            return cell
        })
        
        identifiers = Array(0...30)
        updateSnapshot()
        
        navigationItem.title = "Task 4"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .done, target: self, action: #selector(shuffle))
    }

    @objc private func shuffle() {
        identifiers.shuffle()
        updateSnapshot()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let identifier = identifiers[indexPath.row]
        if selectedIdentifiers.contains(identifier) {
            selectedIdentifiers.remove(identifier)
            snapshot.reconfigureItems([identifier])
            dataSource.apply(snapshot, animatingDifferences: true)
        } else {
            identifiers.remove(at: indexPath.row)
            identifiers.insert(identifier, at: 0)
            selectedIdentifiers.insert(identifier)
            updateSnapshot(reconfigure: [identifier])
        }
    }

}


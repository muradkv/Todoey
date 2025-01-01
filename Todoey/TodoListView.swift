//
//  TodoListView.swift
//  Todoey
//
//  Created by murad on 19.12.2024.
//

import UIKit
import SwipeCellKit

class TodoListView: UIView {
    
    //MARK: - Properties
    
    private let searchBar: UISearchBar = {
        let searchB = UISearchBar()
        searchB.translatesAutoresizingMaskIntoConstraints = false
        searchB.placeholder = "Search..."
        searchB.backgroundColor = .white
        searchB.searchTextField.backgroundColor = .systemBackground
        searchB.autocorrectionType = .no
        searchB.returnKeyType = .search
        searchB.autocapitalizationType = .sentences
        searchB.autocorrectionType = .no
        searchB.spellCheckingType = .no
        return searchB
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "SwipeCell")
        tableView.rowHeight = 80
        return tableView
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    
    private func setupView() {
        addSubview(searchBar)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    //MARK: - Methods
    
    func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func setSearchBarDelegate(_ delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func updateSearchBar(barTintColor: UIColor?) {
        searchBar.barTintColor = barTintColor    }
}

//
//  CategoryViewController.swift
//  Todoey
//
//  Created by murad on 27.12.2024.
//

import UIKit

class CategoryViewController: UIViewController {
    //MARK: - Properties
    
    let categoryView = CategoryView()
    var itemArray = ["Item", "asdad", "asdasdasd"]
    
    //MARK: - Life cycle
    
    override func loadView() {
        view = categoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        setDelegates()
        setupAddButton()
    }
    
    //MARK: - Methods
    
    private func setDelegates() {
        categoryView.setTableViewDataSource(self)
        categoryView.setTableViewDelegate(self)
    }
    
    private func configureNavBar() {
        navigationItem.title = "Todoey"
    }
    
    private func setupAddButton() {
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    @objc private func addButtonTapped() {
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item
        print(itemArray[indexPath.row])
        
        return cell 
    }
}

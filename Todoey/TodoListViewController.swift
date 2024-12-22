//
//  ViewController.swift
//  Todoey
//
//  Created by murad on 19.12.2024.
//

import UIKit

class TodoListViewController: UIViewController {
    
    //MARK: - Properties
    
    let todoListView = TodoListView()
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    let defaults = UserDefaults()
    
    //MARK: - Life cycle
    
    override func loadView() {
        view = todoListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        setDelegates()
        setupAddButton()
        
        if let item = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = item 
        }
    }
    
    //MARK: - Methods
    
    private func setDelegates() {
        todoListView.setTableViewDataSource(self)
        todoListView.setTableViewDelegate(self)
    }
    
    private func configureNavBar() {
        navigationItem.title = "Todoey"
    }
    
    private func setupAddButton() {
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    @objc private func addButtonTapped() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.todoListView.reloadTableView()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
}

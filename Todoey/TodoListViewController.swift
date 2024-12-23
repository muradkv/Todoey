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
    var itemArray = [
        Item(title: "Find Mike", done: false),
        Item(title: "Buy Eggos", done: true),
        Item(title: "Destroy Demogorgon", done: false)]
    let defaults = UserDefaults()
    
    //MARK: - Life cycle
    
    override func loadView() {
        view = todoListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let dataFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        configureNavBar()
        setDelegates()
        setupAddButton()
        
        if let item = defaults.array(forKey: "TodoListArray") as? [Item] {
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
            let newItem = Item(title: textField.text!, done: false)
            self.itemArray.append(newItem)
                    
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
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        todoListView.reloadTableView()
    }
}

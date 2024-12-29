//
//  ViewController.swift
//  Todoey
//
//  Created by murad on 19.12.2024.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UIViewController {
    
    //MARK: - Properties
    
    let todoListView = TodoListView()
    let realm = try! Realm()
    var toDoItems: Results<ItemRealm>?
    
    var selectedCategory: CategoryRealm? {
        didSet {
            loadItems()
        }
    }
    
    //MARK: - Life cycle
    
    override func loadView() {
        view = todoListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        setDelegates()
        setupAddButton()
    }
    
    //MARK: - Methods
    
    private func setDelegates() {
        todoListView.setTableViewDataSource(self)
        todoListView.setTableViewDelegate(self)
        todoListView.setSearchBarDelegate(self)
    }
    
    private func configureNavBar() {
        navigationItem.title = "Item"
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
            
            let newItem = ItemRealm()
            newItem.title = textField.text!
            newItem.date = Date()
            self.save(item: newItem)
            self.todoListView.reloadTableView()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK: - Methods CoreData
    
    private func save(item: ItemRealm) {
        if let currentCategory = selectedCategory {
            do {
                try realm.write {
                    currentCategory.items.append(item)
                }
            } catch {
                print("Error encoding item array, \(error)")
            }
        }
    }
    
    private func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    private func delete(item: ItemRealm) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Cant delete item from Realm - \(error)")
        }
    }
}

//MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            print("Search text is empty")
            return
        }
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        
        todoListView.reloadTableView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            todoListView.reloadTableView()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        todoListView.reloadTableView()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let item = toDoItems?[indexPath.row] else { return }
        
        if editingStyle == .delete {
            delete(item: item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

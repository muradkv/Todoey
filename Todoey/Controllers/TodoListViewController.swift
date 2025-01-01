//
//  ViewController.swift
//  Todoey
//
//  Created by murad on 19.12.2024.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonSwift

class TodoListViewController: SwipeTableViewController {
    
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
        
        setDelegates()
        setupAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeNavBarColor()
    }
    
    //MARK: - Methods
    
    private func setDelegates() {
        todoListView.setTableViewDataSource(self)
        todoListView.setTableViewDelegate(self)
        todoListView.setSearchBarDelegate(self)
    }
    
    //MARK: - Methods NavBar
    
    private func configureNavBar() {
        navigationItem.title = selectedCategory?.name
                
        if let colorHex = selectedCategory?.colorRow, let uicolor = UIColor(hexString: colorHex) {
            let contrastColor = ContrastColorOf(uicolor, returnFlat: true)
            
            changeNavBarColor(uicolor, tintColor: contrastColor)
            todoListView.updateSearchBar(barTintColor: uicolor)
            setupAddButton(tintColor: contrastColor)
        }
    }
    
    private func changeNavBarColor(
        _ backgroundColor: UIColor = Constants.NavigationBarColors.backgroundColor,
        tintColor: UIColor = Constants.NavigationBarColors.tintColor) {
            // Получаем текущую конфигурацию навбара
            let appearance = navigationController?.navigationBar.standardAppearance.copy() as? UINavigationBarAppearance ?? UINavigationBarAppearance()
            
            // Меняем цвет фона
            appearance.backgroundColor = backgroundColor
            appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: tintColor]
            appearance.largeTitleTextAttributes = [.foregroundColor: tintColor]
            navigationController?.navigationBar.tintColor = tintColor
            
            // Применяем новую конфигурацию
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    
    private func setupAddButton(tintColor: UIColor = .white) {
        let plusImage = UIImage(systemName: "plus")?.withTintColor(tintColor, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
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
    
    override func updateModel(at indexPath: IndexPath) {
        let sortedItems = toDoItems?.sorted(byKeyPath: "date")
        guard let item = sortedItems?[indexPath.row] else { return }
        delete(item: item)
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

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        var colorForRows: UIColor?
        
        let sortedItems = toDoItems?.sorted(byKeyPath: "date")
        
        if let item = sortedItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let category = selectedCategory, let color = category.colorRow {
                colorForRows = UIColor(hexString: color)
            }
            
            let percentegeResult = CGFloat(indexPath.row) / CGFloat(toDoItems?.count ?? 0)
            let colorForCell = colorForRows?.darken(byPercentage: percentegeResult)
            cell.backgroundColor = colorForCell
            cell.textLabel?.textColor = ContrastColorOf(colorForCell!, returnFlat: true)
            
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sortedItems = toDoItems?.sorted(byKeyPath: "date")
        
        if let item = sortedItems?[indexPath.row] {
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
}

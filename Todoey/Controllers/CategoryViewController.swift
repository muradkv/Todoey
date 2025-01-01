//
//  CategoryViewController.swift
//  Todoey
//
//  Created by murad on 27.12.2024.
//

import UIKit
import RealmSwift
import ChameleonSwift

class CategoryViewController: SwipeTableViewController {
    
    //MARK: - Properties
    
    let categoryView = CategoryView()
    let realm = try! Realm()
    var categories: Results<CategoryRealm>?
    
    //MARK: - Life cycle
    
    override func loadView() {
        view = categoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        setDelegates()
        setupAddButton()
        loadCategories()
    }
    
    //MARK: - Methods
    
    private func setDelegates() {
        categoryView.setTableViewDataSource(self)
        categoryView.setTableViewDelegate(self)
    }
    
    private func configureNavBar() {
        navigationItem.title = Constants.NavigationTitles.mainTitle
    }
    
    private func setupAddButton() {
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    @objc private func addButtonTapped() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            
            let newCategory = CategoryRealm()
            newCategory.name = textField.text!
            newCategory.colorRow = UIColor.randomFlat().hexValue()
                        
            self.save(category: newCategory)
            self.categoryView.reloadTableView()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Methods CoreData
    
    private func save(category: CategoryRealm) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    private func loadCategories() {
        categories = realm.objects(CategoryRealm.self)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let item = categories?[indexPath.row]
        cell.textLabel?.text = item?.name ?? "No categories added"
        
        //Проверяем есть ли цвет в старой базе, если нет присваиваем рандом и сохраняем в базу
        if let color = item?.colorRow, !color.isEmpty {
            let uicolor = UIColor(hexString: color)
            cell.backgroundColor = uicolor
            cell.textLabel?.textColor = ContrastColorOf(uicolor!, returnFlat: true)
        } else {
            let hexColor = UIColor.randomFlat()
            cell.backgroundColor = UIColor.randomFlat()
            cell.textLabel?.textColor = ContrastColorOf(hexColor, returnFlat: true)
            
            do {
                try realm.write {
                    item?.colorRow = hexColor.hexValue()
                }
            } catch {
                print("Error saving color to Realm: \(error)")
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoListVC = TodoListViewController()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            todoListVC.selectedCategory = categories?[indexPath.row]
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(todoListVC, animated: true)
    }
}

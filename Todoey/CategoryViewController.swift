//
//  CategoryViewController.swift
//  Todoey
//
//  Created by murad on 27.12.2024.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    //MARK: - Properties
    
    let categoryView = CategoryView()
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        navigationItem.title = "Todoey"
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
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            self.categoryView.reloadTableView()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Methods CoreData
    
    private func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    private func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categories[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            
        let todoListVC = TodoListViewController()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            todoListVC.selectedCategory = categories[indexPath.row]
        }
        
        navigationController?.pushViewController(todoListVC, animated: true)
    }
}

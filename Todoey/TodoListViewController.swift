//
//  ViewController.swift
//  Todoey
//
//  Created by murad on 30.08.2022.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["Food", "Mood", "Good"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureNavigationBar()
        
    }
    
    private func configureNavigationBar() {
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.systemBlue
        navBarAppearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0), .foregroundColor: UIColor.white]
        
        // Customizing our navigation bar
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}

//MARK: - Tableview Datasource & Delegate Methods

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell") else { return UITableViewCell() }
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


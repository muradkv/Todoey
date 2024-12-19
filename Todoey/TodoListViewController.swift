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
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    //MARK: - Life cycle
    
    override func loadView() {
        view = todoListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
    }
    
    //MARK: - Methods
    
    private func setDelegates() {
        todoListView.setTableViewDataSource(self)
        todoListView.setTableViewDataSource(self)
    }


}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
}

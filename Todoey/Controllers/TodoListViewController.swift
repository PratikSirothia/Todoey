//
//  ViewController.swift
//  Todoey
//
//  Created by Pratik Sirothia on 24/11/18.
//  Copyright © 2018 Pratik Sirothia. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ittem1 = Item()
        ittem1.title = "One"
        itemArray.append(ittem1)
        
        let ittem2 = Item()
        ittem2.title = "Two"
        itemArray.append(ittem2)
        // Do any additional setup after loading the view, typically from a nib.
        if let items = userDefaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
    }

    // MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        return cell
    }

    // MARK - TableView DelegateMethods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - addAction
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let item = Item()
            item.title = textField.text!
            self.itemArray.append(item)
            self.userDefaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextFiled) in
            alertTextFiled.placeholder = "Create new Item"
            textField = alertTextFiled
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}


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
    let dataFilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        // Do any additional setup after loading the view, typically from a nib.
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
        saveItem()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - addAction
    fileprivate func saveItem() {
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode( itemArray)
            try data.write(to: dataFilepath!)
        }catch{
            print("Something went wrong\(error)")
        }
    }
    
    fileprivate func loadItems() {
        if let data = try? Data(contentsOf: dataFilepath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Oops somthing went wrong while decodin\(error)")
            }
            
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let item = Item()
            item.title = textField.text!
            self.itemArray.append(item)
            
            self.saveItem()
            
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


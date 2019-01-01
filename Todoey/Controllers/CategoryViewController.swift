//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pratik Sirothia on 01/01/19.
//  Copyright © 2019 Pratik Sirothia. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var cateArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    // MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cateArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCatCell", for: indexPath)
        
        let item = cateArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        
        return cell
    }
    
    // MARK - TableView DelegateMethods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = cateArray[indexPath.row]
        }
    }
    
    // MARK - addAction
    fileprivate func saveItem() {
        do{
            try context.save()
        }catch{
            print("Something went wrong\(error)")
        }
    }
    
    fileprivate func loadItems(with reuest : NSFetchRequest<Category> = Category.fetchRequest()) {
        do{
            cateArray = try context.fetch(reuest)
            tableView.reloadData()
        }catch{
            print("Oops somthing went wrong while loading\(error)")
        }
    }
    

    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let item = Category(context: self.context)
            item.name = textField.text!
            self.cateArray.append(item)
            
            self.saveItem()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextFiled) in
            alertTextFiled.placeholder = "Create new Category"
            textField = alertTextFiled
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

//
//  ViewController.swift
//  Todoey
//
//  Created by Justin Chambers on 2/15/18.
//  Copyright © 2018 Justin Chambers. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
   var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Buy Cheese"
        itemArray.append(newItem)
        
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
            itemArray = items
            
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
     
        
        
        if item.done == true{
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        
        return cell
        
    }
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
     
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
          
            
       let newItem = Item()
        newItem.title = textfield.text!
            
        self.itemArray.append(newItem)
        self.defaults.set(self.itemArray, forKey: "ToDoListArray")
        self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
            textfield = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
}


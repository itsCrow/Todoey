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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath)
        
        
        loadData()
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
        
        saveItems()
        
     
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
          
            
       let newItem = Item()
        newItem.title = textfield.text!
            
        self.itemArray.append(newItem)
            
        self.saveItems()
    
        
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
            textfield = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("error encoding \(error)")
        }
        
        tableView.reloadData()
        
    }

    func loadData(){
        if let data = try? Data(contentsOf: dataFilePath!){
      
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("error in decoding \(error)")
            }
            
        }
        
        
        
    }
    
    
    
}




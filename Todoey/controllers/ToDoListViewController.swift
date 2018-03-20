//
//  ViewController.swift
//  Todoey
//
//  Created by Justin Chambers on 2/15/18.
//  Copyright © 2018 Justin Chambers. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController {
    
   var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadData()
            
        }
    }
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath!)
        
        
       
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
          
     
        let newItem = Item(context: self.context)
        newItem.done = false
        newItem.parentCategory = self.selectedCategory
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
        
       
        do {
            try context.save()
        }
        catch {
            print("error savig context")
        }
        
        tableView.reloadData()
        
    }

    func loadData(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        request.predicate = predicate
        
        do{
    itemArray = try context.fetch(request)
        }
        catch {
            print("error loading data \(error)")
        }
        tableView.reloadData()
        
}
    
}

//Mark: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
       request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
       request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        do{
            itemArray = try context.fetch(request)
        }
        catch {
            print("error loading data \(error)")
        }
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                
           searchBar.resignFirstResponder()
                
            }
        }
    }
    
    
}



//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Justin Chambers on 3/5/18.
//  Copyright © 2018 Justin Chambers. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    var categoryArray: Array = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    //Mark: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        
        
        
        return cell
        
    }
     //Mark: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categorySelected", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexpath.row]
        }
    }
 
    
    //Mark: - Add New Categories

    @IBAction func addrButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
           let newCategory = Category(context: self.context)
            
            newCategory.name = textfield.text!
           
            self.categoryArray.append(newCategory)
            do {
                try self.context.save()
            }
            catch{
                print(error)
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textfield = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
       //Mark: - Data Manipulation Methods
    func loadData(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
          categoryArray = try context.fetch(request)
        }
        catch{
            print("failed to load data \(error)")
        }
        tableView.reloadData()
    }
    
   
}

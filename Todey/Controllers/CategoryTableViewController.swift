//
//  CategoryTableViewController.swift
//  Todey
//
//  Created by lw-dlf on 3/26/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import UIKit
import CoreData
class CategoryTableViewController: UITableViewController {
  var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            self.categoryArray.append(newItem)
            self.saveCategory()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
      
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categoryArray[indexPath.row]
        cell.textLabel?.text = item.name
//        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

      performSegue(withIdentifier: "goToItems", sender: self)

        //Save
        saveCategory()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    // MARK: - Data Manupilation Methods
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            
        }
        tableView.reloadData()
    }
    
    

}

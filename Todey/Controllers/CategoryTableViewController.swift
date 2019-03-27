//
//  CategoryTableViewController.swift
//  Todey
//
//  Created by lw-dlf on 3/26/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryTableViewController: UITableViewController {
    var categoryArray : Results<Category>?
    let realm = try! Realm()
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
//            self.categoryArray.append(newCategory)
            self.saveCategory(category: newCategory)
            
            
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
       loadCategories()
      
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categoryArray?[indexPath.row]
        cell.textLabel?.text = item?.name ?? "No Categories Added Yet"
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

      performSegue(withIdentifier: "goToItems", sender: self)

        //Save
//        saveCategory()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    // MARK: - Data Manupilation Methods
    
    func saveCategory(category : Category) {
        do {
            try realm.write {
                realm.add(category)
                }
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
        
    }
    func loadCategories() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
//    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
////        do {
////            categoryArray = try context.fetch(request)
////        } catch {
////
////        }
////        tableView.reloadData()
//    }
//    
    

}

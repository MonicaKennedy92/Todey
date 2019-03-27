//
//  TodoListViewController.swift
//  Todey
//
//  Created by lw-dlf on 3/21/19.
//  Copyright © 2019 lw-dlf. All rights reserved.
//

import UIKit
import RealmSwift
class TodoListViewController: UITableViewController {
    let realm = try! Realm()
   var defaults = UserDefaults.standard
    var todoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    @IBOutlet weak var searchbar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        searchbar.delegate = self
       // print(dataFilePath)
        
//        let newItem = Item()
//        newItem.title = "One"
//        itemArray.append(newItem)
//
//
//        let newItem1 = Item()
//        newItem1.title = "Two"
//        itemArray.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "Three"
//        itemArray.append(newItem2)
       
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none

        } else {
            cell.textLabel?.text = "No Item Added"

        }

        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        //Update
        
        if let item = todoItems?[indexPath.row] {
//            do {
//                try realm.write {
//                    item.done = !item.done
//                }
//            } catch {
//                print(error)
//            }
           // Delete realmå
                        do {
                            try realm.write {
                               realm.delete(item)
                            }
                        } catch {
                            print(error)
                        }

        }
        
        tableView.reloadData()
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")
     //   itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Delete
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //Save
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    //MArk - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print(error)
                }
               
            }
            
         self.tableView.reloadData()
//
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
//            self.saveItems()
           
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
       present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Data Manupilation Methods
    
    func saveItems() {
//        do {
//          try context.save()
//        } catch {
//            print(error)
//        }
//
        self.tableView.reloadData()

    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
         tableView.reloadData()
    }
    
    
    
}
// MARK: - SearchBar Methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        // Realm
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        // CORE DATA
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        print(searchbar.text!)
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchbar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request,predicate: predicate)
        
        tableView.reloadData()
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchbar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

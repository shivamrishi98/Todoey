//
//  ViewController.swift
//  Todoey
//
//  Created by Shivam Rishi on 01/08/19.
//  Copyright © 2019 Shivam Rishi. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    
    var selectedCategory : Category?
    {
        didSet
        {
           loadItems()
        }
    }
    
  
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

      
    }
    
    
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        
        cell.textLabel?.text = item.title
        
        
        
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row]
        {
            do
            {
               try realm.write {
                    item.done = !item.done
                }
            }
            
            catch
            {
                print("\(error)")
            }
        }
        
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {

            if let item = todoItems?[indexPath.row]
            {
                do
                {
                    try realm.write {
                        realm.delete(item)
                    }
                }
                    
                catch
                {
                    print("\(error)")
                }
            }
            tableView.reloadData()
            
    }
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
        
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        //what will happen once the user clicks the Add Item Button on our UIAlert
     if textField.text != ""
     {
        
       if let currentCategory = self.selectedCategory
       {
        do {
            try self.realm.write {
                
            
            let newItem = Item()
        newItem.title = textField.text!
        newItem.dateCreated = Date()
       currentCategory.items.append(newItem)
        }
        }
            catch
            {
                print("\(error)")
            }
        
        
        }
        
        self.tableView.reloadData()
       
        
    
     } else {
        print("Empty String")
        
//        let innerAlert = UIAlertController(title: nil, message: "Empty String cannot be added", preferredStyle: .alert)
//        innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
//        self.present(innerAlert, animated: true, completion: nil)
//
        
        }
        
        }
    
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    
    }
    
    //MARK:- Model Manupulation Methods
    
 
    
    
    func loadItems()
    {
        
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        

        tableView.reloadData()
    }

}

    

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate
{

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//
//
//
//    }
    
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty
        {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        } else {
            
             todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
          
        }
      tableView.reloadData()

    }


}


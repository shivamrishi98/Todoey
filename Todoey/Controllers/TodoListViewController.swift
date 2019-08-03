//
//  ViewController.swift
//  Todoey
//
//  Created by Shivam Rishi on 01/08/19.
//  Copyright © 2019 Shivam Rishi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let item1 = Item()
        item1.title = "go to school"
        itemArray.append(item1)
        
        let item2 = Item()
        item2.title = "go to college"
        itemArray.append(item2)
        
        let item3 = Item()
        item3.title = "go to market"
        itemArray.append(item3)
       
       
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
            itemArray = items
        }
    }
    
    
    
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
          itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
     //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
        
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        //what will happen once the user clicks the Add Item Button on our UIAlert
     if textField.text != ""
     {
        let newItem = Item()
        newItem.title = textField.text!
        self.itemArray.append(newItem)
        
        self.defaults.set(self.itemArray, forKey: "TodoListArray")
        
        print(textField.text!)
     } else {
        print("Empty String")
        
//        let innerAlert = UIAlertController(title: nil, message: "Empty String cannot be added", preferredStyle: .alert)
//        innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
//        self.present(innerAlert, animated: true, completion: nil)
//
        
        }
        
        self.tableView.reloadData()
        
        }
    
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
}


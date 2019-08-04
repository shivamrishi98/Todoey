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
    
   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(dataFilePath)
        
      
       
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
        
        loadItems()
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
        
          saveItems()

        
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
        
        self.saveItems()
        
        print(textField.text!)
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
    
    //MARK - Model Manupulation Methods
    
    func saveItems()
    {
        let encoder = PropertyListEncoder()
    
        do
        {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems()
    {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
               
            } catch{
                print("error \(error)")
            }
        }
        
    }
    
}


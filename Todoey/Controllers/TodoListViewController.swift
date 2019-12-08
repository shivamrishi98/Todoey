//
//  ViewController.swift
//  Todoey
//
//  Created by Shivam Rishi on 01/08/19.
//  Copyright © 2019 Shivam Rishi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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

        tableView.separatorStyle = .none
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    
        if let colorHex = selectedCategory?.colorHex
        {
            
            
            title = selectedCategory!.name
            
            guard let navbar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exist.")
            }
            
            
            if let navBarColor = UIColor(hexString: colorHex)
            {
                if #available(iOS 13.0, *) {
                    let appearance = UINavigationBarAppearance().self
                                    
                    appearance.backgroundColor = navBarColor
                    appearance.largeTitleTextAttributes = [
                        NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                 
                    navbar.standardAppearance = appearance
                    navbar.compactAppearance = appearance
                    navbar.scrollEdgeAppearance = appearance
                    navbar.tintColor = ContrastColorOf(navBarColor,returnFlat: true)
                                    
                } else {
                    navbar.barTintColor = navBarColor
                    navbar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                    navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                }
                
//                navbar.backgroundColor = navBarColor
//
//                navbar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
//
//                navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
//
                searchBar.barTintColor = navBarColor
                searchBar.searchTextField.backgroundColor = FlatWhite()
                
            }
        }
        
    }
    
    
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
         let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        
        cell.textLabel?.text = item.title
        
              
            if let color = UIColor(hexString: selectedCategory!.colorHex)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count))
            {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        
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
        
        let innerAlert = UIAlertController(title: nil, message: "Empty String cannot be added", preferredStyle: .alert)
        innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        self.present(innerAlert, animated: true, completion: nil)

        
        }
        
        }
    
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    
    }
    
    
    
    //MARK: - Delete Data from swipe
     override func updateModel(at indexPath: IndexPath)
     {
         
          if let item = self.todoItems?[indexPath.row]
                     {
                         do
                         {
                             try self.realm.write {
                                 self.realm.delete(item)
                             }
                         }
         
                         catch
                         {
                             print("\(error)")
                         }
                     }
     }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//           if editingStyle == .delete
//           {
//
//               if let item = todoItems?[indexPath.row]
//               {
//                   do
//                   {
//                       try realm.write {
//                           realm.delete(item)
//                       }
//                   }
//
//                   catch
//                   {
//                       print("\(error)")
//                   }
//               }
//               tableView.reloadData()
//
//       }
//       }
    
    
    
    
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


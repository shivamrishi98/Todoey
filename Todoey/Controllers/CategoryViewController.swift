//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shivam Rishi on 06/08/19.
//  Copyright © 2019 Shivam Rishi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {

    
    var categoryArray : Results<Category>?
    
    let realm = try! Realm()
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      loadCategories()
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navbar = navigationController?.navigationBar else {
                     fatalError("Navigation controller does not exist.")
                 }
        
        if let navBarColor = UIColor(hexString: "1D9BF6")
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
                    
                    
                    
                    
                    
                    
                    
                    
                    
//                    navbar.backgroundColor = navBarColor
//
//                    navbar.tintColor = ContrastColorOf(navbar.backgroundColor!, returnFlat: true)
//
//                       navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
//
//
                       
                   }
        
      
        
        
        
        
    }
    
    
    
    //MARK: - Delete Data from swipe
    override func updateModel(at indexPath: IndexPath)
    {
        
         if let item = self.categoryArray?[indexPath.row]
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
    
    
    
    

    //MARK: - Add New Categories
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != ""
            {
                
                let newCategory = Category()
                
                newCategory.name = textField.text!
                newCategory.colorHex = UIColor.randomFlat().hexValue()
                self.save(category: newCategory)
            
            } else {
                print("Empty String")
            }
            
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                 let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
                let category = categoryArray?[indexPath.row]
                
                cell.textLabel?.text = category?.name ?? "No category added yet"
     
        if let color = UIColor(hexString: category?.colorHex ?? "1d98f6")
        {
            cell.backgroundColor = color
    
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                  
        }
              
                return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
    }
    

    //MARK: - Data Manipulation Methods

    func save(category : Category)
    {
        do {
            try realm.write {
                realm.add(category)
            }
        }
            
        catch
        {
            print("error \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories()
    {
        
       categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
    
}


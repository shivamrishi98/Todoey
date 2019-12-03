//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shivam Rishi on 06/08/19.
//  Copyright © 2019 Shivam Rishi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    
    var categoryArray : Results<Category>?
    
    let realm = try! Realm()
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      loadCategories()
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No category added yet"
        
        
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

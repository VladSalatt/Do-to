//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by OUT-Koshelev-VO on 08.04.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
// MARK: - Add Category Section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            let newCategoty = Category()
            newCategoty.name = textField.text!
            self.save(category: newCategoty)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table View Data Source

extension CategoryTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCell, for: indexPath)
        
        cell.textLabel?.text = category?.name ?? "No categories to Added yet"
        return cell
    }
}

// MARK: - Data Model Methods

extension CategoryTableViewController {
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data with context: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}

// MARK: - Table View Delegate

extension CategoryTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.goToItems, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.seletcedCategory = categories?[indexPath.row]
        }
    }
}


//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by OUT-Koshelev-VO on 08.04.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("navigation controller does not exist")
        }
        guard let navBarColor = UIColor(hexString: "9B1C1F") else {
            fatalError("Color does not exist")
        }
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: navBarColor]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)
        ]
        navBarAppearance.backgroundColor = navBarColor
        navBar.standardAppearance = navBarAppearance
        navBar.scrollEdgeAppearance = navBarAppearance
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
    }
    
    // MARK: - Add Category Section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            let newCategoty = Category()
            newCategoty.name = textField.text!
            newCategoty.color = UIColor.randomFlat().hexValue()
            self.save(category: newCategoty)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Model Methods
    
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error with deletion. \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Table View Data Source

extension CategoryTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row]
        
        guard let categoryColor = UIColor(hexString: category?.color ?? "9B1C1F") else {
            fatalError()
        }
        
        cell.textLabel?.text = category?.name ?? "No categories to Added yet"
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        cell.backgroundColor = categoryColor
        return cell
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
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}

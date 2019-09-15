    //
    //  CategoryTableViewController.swift
    //  Todoey
    //
    //  Created by Vikass s on 13/09/19.
    //  Copyright © 2019 Chips PVT LTD. All rights reserved.
    //

    import UIKit
    import RealmSwift
    import ChameleonFramework

    class CategoryTableViewController: SwipeTableViewController{
    //code smell possibly bad code maybe debug problem
    let realm = try! Realm()
    var categories: Results<Category>?




    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.separatorStyle = .none

    }
      //Mark - Tableview Delegate Methods
    //Table view to category viecontroller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }



    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }




    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
        cell.textLabel?.text = category.name ?? "No Categories Added yet"
        cell.backgroundColor = UIColor(hexString: category.colour ?? "1D9BF6")
        }

        
       
        return cell
    }


    //Mark - DataManipulation Methods
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error \(error)")
        }
        
        tableView.reloadData()
    }

    func loadCategories() {
        categories = realm.objects(Category.self)
        

        tableView.reloadData()
    }

    //Mark: delete data
    override func updateModel(at indexPath: IndexPath){
        super.updateModel(at: indexPath)
                        if let categoryForDeletion = self.categories?[indexPath.row]{
                            do {
                                try self.realm.write {
                                    self.realm.delete(categoryForDeletion)
                                }
                            } catch {
                                print("error deleeting \(error)")
                            }
                        }
    }

    //Mark - Add new catageroy
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: " ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            
            self.save(category: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField{ (field) in
            textField = field
            textField.placeholder = "Add a new Categorey"
            
        }
        present(alert, animated: true, completion: nil)
    }



    }





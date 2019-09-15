    //
    //  ViewController.swift
    //  Todoey
    //
    //  Created by Vikass s on 12/09/19.
    //  Copyright © 2019 Chips PVT LTD. All rights reserved.
    //

    import UIKit
    import RealmSwift
    import ChameleonFramework

    class TodoListViewController: SwipeTableViewController {
    let realm = try! Realm()
    var todoItems: Results<Item>?

    @IBOutlet weak var searchBar: UISearchBar!

    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }

    //     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext




    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      
        
    }

    override func viewWillAppear(_ animated: Bool){
        
        
    if let colourHex = selectedCategory?.colour {
        title = selectedCategory!.name
    guard let navBar = navigationController?.navigationBar else {
    fatalError("Navigation controller")}
        
        if let navBarColour = UIColor(hexString: colourHex){
            navBar.barTintColor = navBarColour
            navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
            
        searchBar.barTintColor = navBarColour
        }
        

    }
    }




    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if the todoitems is not nill then return the key if it is nil then return 1
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
      
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage:
                CGFloat(indexPath.row) /  CGFloat(todoItems!.count)) {
                      cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true )
                }
            
         
          
            //Terinary operator
            // value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }

    //MARK TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
    //                    realm.delete(item)
                item.done = !item.done
            }
        } catch {
            print("error update")
        }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }



    //Mark ADD New Items
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in
            // what will happen once the user clicks the add button on our UIAlert
            
            //we are tapping into uiapplicatio shared object delegate and casting to our appdelegate its property pc
           
           // let newItem = Item()
            if let currentCategory = self.selectedCategory{
                do {
                try self.realm.write{
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                }catch{
                    print("error saving new item\(error)")
                }
            }
         
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
            
           
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }




    //ecoding and decoding
    //encoder to save

    //decoder to load from saved item
    //external and internal parameter and also with a default value
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }

    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                realm.delete(item)
            }
            } catch {
                print("error deleting item \(error)")
            }
    }


    }

    }
    ////MARK Search Bar methods
    extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
    }

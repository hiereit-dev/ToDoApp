//
//  TodoListTableViewController.swift
//  TodoApp
//
//  Created by 박세라 on 3/20/25.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    var items = [TodoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        
        configureTableView()
        
        reloadTodoListView()
    }
    
    private func configureNavigation() {
        title = "할일 목록"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addNewItem)
        )
    }
    
    private func configureTableView() {
        tableView.register(TodoListCell.self, forCellReuseIdentifier: "TodoListCell")
        
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func reloadTodoListView() {
        print("reload Data")
        
        Task {
            let loadedItems = await DataManager.shared.loadTodoItems()
            items = loadedItems
            tableView.reloadData()
        }
    }
    
    @objc func addNewItem() {
        let addVC = AddTodoViewController()
        addVC.navigationDataDelegate = self
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoListCell
        let item = items[indexPath.row]
        cell.configure(item: item)
        cell.checkBoxHandler = { [weak self] checked in
            Task {
                print("checked:\(checked)")
                await DataManager.shared.updateTodoItemStatus(item: item, isChecked: checked)
                self?.reloadTodoListView()
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        
        let alert = UIAlertController(title: "아이템 삭제", message: "\(item.title)을/를 삭제하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            DataManager.shared.deleteItem(item)
            self?.reloadTodoListView()
        })
        present(alert, animated: true)
    }
}


extension TodoListTableViewController: NavigationDelegate {
    func receiveData(_ data: Any) {
        if let data = data as? String {
            DataManager.shared.saveTodoItems(TodoItem(title: data, createdAt: Date()))
            reloadTodoListView()
        }
    }
}

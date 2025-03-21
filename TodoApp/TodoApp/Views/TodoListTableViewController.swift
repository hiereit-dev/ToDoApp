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
        
        configureSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadTodoListView()
    }
    
    private func configureNavigation() {
        title = "할일 목록"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // 우측 할일 추가 BarButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addNewItem)
        )
        
        // 좌측 할일 필터링 BarButton
        let doneFilter = UIAction(title: "완료한 일", image: UIImage(systemName: "checkmark.square.fill")) { [weak self] _ in
            self?.filterItems(checked: true)
        }
        let todoFilter = UIAction(title: "해야할 일", image: UIImage(systemName: "pencil")) { [weak self] _ in
            self?.filterItems(checked: false)
        }
        
        let menu = UIMenu(title: "필터", children: [doneFilter, todoFilter])
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), menu: menu)
        
        navigationItem.leftBarButtonItem = menuButton
        
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
    
    func filterItems(checked: Bool) {
        Task {
            items = await DataManager.shared.searchTodoItemsWithChecked(checked)
            self.tableView.reloadData()
        }
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
        
        let alert = UIAlertController(title: "할일 수정", message: "", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.text = item.title
            textField.placeholder = "할일을 수정해주세요."
            textField.keyboardType = .default
        }

        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            Task {
                if let inputText = alert.textFields?.first?.text {
                    await DataManager.shared.updateTodoItem(item: item, title: inputText)
                    self?.reloadTodoListView()
                }
            }
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: NavigationDelegate
extension TodoListTableViewController: NavigationDelegate {
    func receiveData(_ data: [String: Any]) {
        if let title = data["title"] as? String,
           let content = data["content"] as? String {
            DataManager.shared.saveTodoItems(TodoItem(title: title, content: content, createdAt: Date()))
            reloadTodoListView()
        }
    }
}

extension TodoListTableViewController: UISearchResultsUpdating {
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "검색"
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    func searchTodoItems(_ text: String) async {
        if text.isEmpty {
            reloadTodoListView()
            return
        }
        
        items = await DataManager.shared.searchTodoItemsWithKeyword(text)
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        Task {
            await searchTodoItems(text)
        }
    }
}

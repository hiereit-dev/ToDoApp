//
//  TodoListTableViewController.swift
//  TodoApp
//
//  Created by 박세라 on 3/20/25.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    // todo Data
    var items = [TodoItem]()
    
    // items가 비어있을 때 노출시키는 뷰
    let emptyView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        
        configureTableView()
        
        configureSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadTodoListView()
        
        setupEmptyView()
    }
    
    // empty View 설정
    private func setupEmptyView() {
        let emptyIconView = UIImageView(image: UIImage(systemName: "plus.square.dashed"))
        emptyIconView.tintColor = .systemGray5
        let titleLabel = UILabel()
        titleLabel.text = "할일을 추가해주세요!"
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyIconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyView)
        emptyView.addSubview(emptyIconView)
        emptyView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyIconView.widthAnchor.constraint(equalToConstant: 100),
            emptyIconView.heightAnchor.constraint(equalToConstant: 100),
            emptyIconView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyIconView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: emptyIconView.bottomAnchor, constant: 16)
        ])
        
        emptyView.isHidden = !(items.isEmpty)
    }
    
    // navigation 설정
    private func configureNavigation() {
        title = "할일 목록"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // 우측 할일 추가 BarButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addNewItem)
        )
        
        // 좌측 할일 필터링 BarButton -> "UIMenu" 설정
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
    
    // 테이블뷰 설정 : customCell 등록, rowHeight 내용물에 맞게 높이 지정되도록 설정
    private func configureTableView() {
        tableView.register(TodoListCell.self, forCellReuseIdentifier: "TodoListCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // 데이터 불러오는 메소드 (데이터 불러오고 테이블 리프레싱)
    private func reloadTodoListView() {
        Task {
            let loadedItems = await DataManager.shared.loadTodoItems()
            items = loadedItems
            tableView.reloadData()
        }
    }
    
    // 할일 추가화면으로 이동
    @objc func addNewItem() {
        let addVC = AddTodoViewController()
        addVC.navigationDataDelegate = self
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    // 필터 적용
    func filterItems(checked: Bool) {
        Task {
            items = await DataManager.shared.searchTodoItemsWithChecked(checked)
            self.tableView.reloadData()
        }
    }
    

    
    
}

// MARK: - Table view data source & delegate
extension TodoListTableViewController {
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
    
    // cell 선택 시 항목 수정하는 Alert
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
    
    // Swipe Action으로 todo 삭제
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = items[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            // 아이템 삭제 처리
            DataManager.shared.deleteItem(item)
            self?.reloadTodoListView()
            
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

// MARK: NavigationDelegate - 다른 화면으로 부터 받아온 데이터를 처리하는 delegate 함수
extension TodoListTableViewController: NavigationDelegate {
    func receiveData(_ data: [String: Any]) {
        if let title = data["title"] as? String,
           let content = data["content"] as? String {
            DataManager.shared.saveTodoItems(TodoItem(title: title, content: content, createdAt: Date()))
            reloadTodoListView()
        }
    }
}


// MARK: UISearchResultsUpdating - 검색 바 관련 delegate 함수
extension TodoListTableViewController: UISearchResultsUpdating {
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "검색"
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = false
    }
    
    func searchTodoItems(_ text: String) async {
        if text.isEmpty {
            reloadTodoListView() // 화면 갱신
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

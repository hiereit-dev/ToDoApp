//
//  AddTodoViewController.swift
//  TodoApp
//
//  Created by 박세라 on 3/21/25.
//

import UIKit

class AddTodoViewController: UIViewController {
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할일을 입력하세요."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true // 초기에 안보이게 처리
        return label
    }()
    
    var navigationDataDelegate: NavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        
        setupUI()
    }
    
    private func configureNavigation() {
        title = "할일 추가"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(saveItem)
        )
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.heightAnchor.constraint(equalToConstant: 44),
            
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8)
        ])
    }
    
    @objc func saveItem() {
        guard let text = textField.text, !text.isEmpty else {
            showErrorMessage("할일을 입력해주세요.")
            return
        }

        // 텍스트가 유효하면 delegate에 데이터 전달하고 화면 이동
        navigationDataDelegate?.receiveData(text)
        self.navigationController?.popViewController(animated: true)
    }

    private func showErrorMessage(_ message: String) {
        messageLabel.text = message
        messageLabel.textColor = .systemRed
        messageLabel.isHidden = false
    }
}

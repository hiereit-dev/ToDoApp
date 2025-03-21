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
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
            
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true // 초기에 안보이게 처리
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.backgroundColor = .systemBlue  // 배경색을 설정하여 버튼이 보이게 함
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let memoPad: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.systemGray6
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 16)
        
        textView.layer.cornerRadius = 8
        textView.clipsToBounds = true
        // textView padding
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        return textView
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
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        memoPad.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        view.addSubview(messageLabel)
        view.addSubview(doneButton)
        view.addSubview(memoPad)
        
        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            doneButton.widthAnchor.constraint(equalToConstant: 60),
            doneButton.heightAnchor.constraint(equalToConstant: 44),
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44),
            
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            
            memoPad.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            memoPad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            memoPad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            memoPad.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        doneButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
    }
    
    @objc func saveItem() {
        guard let text = textField.text, !text.isEmpty else {
            showErrorMessage("할일을 입력해주세요.")
            return
        }

        // 텍스트가 유효하면 delegate에 데이터 전달하고 화면 이동
        navigationDataDelegate?.receiveData(["title": text, "content": memoPad.text ?? ""])
        self.navigationController?.popViewController(animated: true)
    }

    private func showErrorMessage(_ message: String) {
        messageLabel.text = message
        messageLabel.textColor = .systemRed
        messageLabel.isHidden = false
    }
}

/*
#Preview {
    AddTodoViewController()
}
*/

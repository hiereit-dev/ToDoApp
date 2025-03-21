//
//  TodoListCell.swift
//  TodoApp
//
//  Created by 박세라 on 3/20/25.
//

import UIKit

class TodoListCell: UITableViewCell {

    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    let contentLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
     }()
    
    let checkBoxImageView = UIImageView()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    // 체크박스 선택후 데이터 전달 closure
    var checkBoxHandler: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(checkBoxImageView)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            
            checkBoxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkBoxImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkBoxImageView.widthAnchor.constraint(equalToConstant: 24),
            checkBoxImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkBoxImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -8),
            
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            contentLabel.leadingAnchor.constraint(equalTo: checkBoxImageView.trailingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: dateLabel.topAnchor, constant: -8)
        ])
        
        // 체크박스 이미지에 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action : #selector(checkBoxTapped))
        checkBoxImageView.addGestureRecognizer(tapGesture)
        checkBoxImageView.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(item: TodoItem) {
        titleLabel.text = item.title
        contentLabel.text = item.content
        checkBoxImageView.image = (item.isCompleted ?? false) ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        dateLabel.text = "\(item.createdAt.formattedDate)"
    }
    
    @objc func checkBoxTapped(_ sender: Any) {
        checkBoxHandler?(checkBoxImageView.image == UIImage(systemName: "checkmark.square.fill") ? false : true)
        checkBoxImageView.image = checkBoxImageView.image == UIImage(systemName: "checkmark.square.fill") ? UIImage(systemName: "square") : UIImage(systemName: "checkmark.square.fill")
    }
    
}

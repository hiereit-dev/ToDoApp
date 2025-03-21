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
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    let contentLabel = UILabel()
    let checkBoxImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(checkBoxImageView)
        
        NSLayoutConstraint.activate([
            
            checkBoxImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkBoxImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkBoxImageView.widthAnchor.constraint(equalToConstant: 24),
            checkBoxImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkBoxImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -8),
            
            contentLabel.leadingAnchor.constraint(equalTo: checkBoxImageView.trailingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
        ])
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
    
    func configure(title: String, content: String, isChecked: Bool = false) {
        titleLabel.text = title
        contentLabel.text = content
        checkBoxImageView.image = isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
    }

}

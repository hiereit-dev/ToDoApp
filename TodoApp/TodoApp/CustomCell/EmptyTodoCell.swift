//
//  EmptyTodoCell.swift
//  TodoApp
//
//  Created by 박세라 on 3/21/25.
//

import UIKit

class EmptyTodoCell: UITableViewCell {

    let descLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.text = "할일을 추가해 보세요!"
        return label
    }()
    
    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.square.dashed")
        imageView.tintColor = .systemGray4
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(descLabel)
        contentView.addSubview(emptyImageView)
        
        NSLayoutConstraint.activate([
            emptyImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIScreen.main.bounds.height / 3),
            emptyImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 100),
            emptyImageView.heightAnchor.constraint(equalToConstant: 100),
            
            descLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 16),
            descLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            
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

}

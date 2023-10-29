//
//  ItemCell.swift
//  ToDoList
//
//  Created by Sharon Omoyeni Babatunde on 28/10/2023.
//

import UIKit

protocol ItemCellDelegate: AnyObject {
    func toggleIsDone(sender: ItemCell)
}

class ItemCell: BaseCell {
    
    weak var itemCellDelegate: ItemCellDelegate?

    lazy var checkmarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.checkmarkButton.cgColor
        button.addTarget(self, action: #selector(checkmarkButtonTapped), for: .touchUpInside)
        let selectedImage = UIImage(named: "checkmark")
        let clearImage = UIImage(named: "clear")
        button.setImage(selectedImage, for: .selected)
        button.setImage(clearImage, for: .normal)
        return button
    }()

    @objc func checkmarkButtonTapped() {
        if textField.isEditing == false {
            Haptics.playLightImpact()
            itemCellDelegate?.toggleIsDone(sender: self)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .cellBackground
        
//        contentView.addSubview(textField)
//        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80).isActive = true
//        textField.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
//        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        textField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//
//        addSubview(checkmarkButton)
//        checkmarkButton.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -30).isActive = true
//        checkmarkButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        checkmarkButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
//        checkmarkButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        contentView.addSubview(checkmarkButton)
        checkmarkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        checkmarkButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        checkmarkButton.widthAnchor.constraint(equalTo: checkmarkButton.heightAnchor).isActive = true
        checkmarkButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 30).isActive = true
        textField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
    

    


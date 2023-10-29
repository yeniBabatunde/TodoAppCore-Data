//
//  BaseCell.swift
//  ToDoList
//
//  Created by Sharon Omoyeni Babatunde on 28/10/2023.
//

import UIKit

protocol BaseCellDelegate {
    func updateWithTitle(_ sender: BaseCell, title: String)
}

class BaseCell: UITableViewCell {
    
    var baseCellDelegate: BaseCellDelegate?
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .label
        textField.font = UIFont.preferredFont(forTextStyle: .headline)
        textField.delegate = self
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.selectionStyle = .none
        backgroundColor = .viewBackground
        textField.autocorrectionType = .no
        textField.isUserInteractionEnabled = false
    }
}

//MARK: - UITextfield Delegate

extension BaseCell: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let trimmedTitle = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        textField.text = trimmedTitle
        if trimmedTitle == nil || trimmedTitle == "" {
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let title = textField.text {
            baseCellDelegate?.updateWithTitle(self, title: title)
        }
    }
}


//
//  CustomCell.swift
//  ToDoList
//
//  Created by Sharon Omoyeni Babatunde on 28/10/2023.
//

import UIKit

class CategoryCell: BaseCell {
    
    private let cellBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cellBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.cellBorder.cgColor
        return view
    }()
    
    public let quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .bar
        progressView.trackTintColor = .viewBackground
        progressView.progressTintColor = .roundedButton
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0
        return progressView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(cellBackgroundView)
        cellBackgroundView.anchorSize(to: self)
        
        addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: centerXAnchor, constant: 30).isActive = true

        addSubview(quantityLabel)
        quantityLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true

        addSubview(progressView)
        progressView.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: quantityLabel.trailingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 10).isActive = true
    }
}

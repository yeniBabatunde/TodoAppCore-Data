//
//  RoundedButton.swift
//  ToDoList
//
//  Created by Sharon Omoyeni Babatunde on 28/10/2023.
//

import UIKit

class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .roundedButton
        layer.cornerRadius = 30
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .medium)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)
        setImage(image, for: .normal)
        tintColor = .white
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

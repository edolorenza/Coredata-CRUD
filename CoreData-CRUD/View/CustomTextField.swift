//
//  CustomTextField.swift
//  CoreData-CRUD
//
//  Created by Edo Lorenza on 23/06/21.
//

import UIKit

class CustomTextField: UITextField {
    
     init(placeholder: String) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        borderStyle = .none
        layer.cornerRadius = 5.0
        layer.borderWidth = 0.1
        clipsToBounds = true
        textColor = .black
        backgroundColor = .init(white: 0.5, alpha: 0.1)
        keyboardAppearance = .light
        keyboardType = .alphabet
        setHeight(50)
        attributedPlaceholder = NSAttributedString(string: placeholder)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) Has Not Been Implemented")
    }
    
}

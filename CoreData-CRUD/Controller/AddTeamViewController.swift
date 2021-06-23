//
//  AddTeamViewController.swift
//  CoreData-CRUD
//
//  Created by Edo Lorenza on 23/06/21.
//

import UIKit

class AddTeamViewController: UIViewController {
    //MARK: - Properties
    private let firstNameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "First Name")
        tf.keyboardType = .default
        return tf
    }()
    
    private let lastNameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Last Name")
        tf.keyboardType = .default
        return tf
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(50)
        button.isEnabled = true
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).withAlphaComponent(1.0)
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return button
    }()
    
    private let previewImageview: UIImageView =  {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let chooseImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Choose Image", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(handleChooseImageButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Avenger Team"
        view.backgroundColor = .systemBackground
        setupView()
    }
    
    
    //MARK: - Actions
    @objc func handleSaveButton() {
        print("DEBUG: save button pressed")
    }
    
    @objc func handleChooseImageButton() {
        print("DEBUG: choose image button pressed ")
    }
    
    //MARK: - Helpers
    private func setupView(){
        let stack = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, emailTextField, datePicker, saveButton])
        stack.axis = .vertical
        stack.spacing = 8
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 24, paddingRight: 24)
        
        view.addSubview(previewImageview)
        previewImageview.anchor(top: stack.bottomAnchor, left: view.leftAnchor, paddingTop: 8, paddingLeft: 24)
        previewImageview.setDimensions(height: 100, width: view.frame.width/2)
        
        view.addSubview(chooseImageButton)
        chooseImageButton.centerY(inView: previewImageview)
        chooseImageButton.anchor(left: previewImageview.rightAnchor, paddingLeft: 4)
        
    }
    

}

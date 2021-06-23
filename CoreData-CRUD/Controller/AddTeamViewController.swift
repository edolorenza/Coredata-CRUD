//
//  AddTeamViewController.swift
//  CoreData-CRUD
//
//  Created by Edo Lorenza on 23/06/21.
//

import UIKit
import CoreData

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
    
    private let imagePicker = UIImagePickerController()
    
    var avengerID = 0
    
    //declare coredata from appdelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Avenger Team"
        view.backgroundColor = .systemBackground
        setupView()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    
    //MARK: - Actions
    @objc func handleSaveButton() {
        guard let firstName = firstNameTextField.text, firstName != "" else{
            let alertController = UIAlertController(title: "warning", message: "first name is required", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "yes", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let lastName = lastNameTextField.text, lastName != "" else{
            let alertController = UIAlertController(title: "warning", message: "last name is required", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "yes", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let email = emailTextField.text, email != "" else{
            let alertController = UIAlertController(title: "warning", message: "email is  required", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "yes", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        let birhtDate = dateFormatter.string(from: datePicker.date)
        
        //check from edit or add VC
        if avengerID > 0 {
            let avengerFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Avengers")
            avengerFetch.fetchLimit = 1
            // condition with predicate
            avengerFetch.predicate = NSPredicate(format: "id == \(avengerID)")
            
            //run
            let result = try! context.fetch(avengerFetch)
            let avengers: Avengers = result.first as! Avengers
            
            avengers.firstName = firstName
            avengers.lastName = lastName
            avengers.email = email
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM YYYY"
            let birhtDate = dateFormatter.string(from: datePicker.date)
            avengers.birthDate = birhtDate
            
            if let img = previewImageview.image {
                let data = img.pngData() as NSData?
                avengers.image = data as Data?
            }
            
            // save to coreData
            do {
                try context.save()
            }
            catch{
                print(error.localizedDescription)
            }
        }
        
        else {
            // add to avengers entity
            let avengers = Avengers(context: context)
            
            //auto increment
            let request: NSFetchRequest = Avengers.fetchRequest()
            let sortDescriptors = NSSortDescriptor(key: "id", ascending: false)
            request.sortDescriptors = [sortDescriptors]
            request.fetchLimit = 1
            
            var maxID = 0
            
            do {
                let lastAvenger = try context.fetch(request)
                maxID = Int(lastAvenger.first?.id ?? 0)
            } catch  {
                print(error.localizedDescription)
            }
            avengers.id = Int32(maxID) + 1
            avengers.firstName = firstName
            avengers.lastName = lastName
            avengers.email = email
            avengers.birthDate = birhtDate
            
            if let img = previewImageview.image {
                let data = img.pngData() as NSData?
                avengers.image = data as Data?
            }
            
            // save to coreData
            do {
                try context.save()
            }
            catch{
                print(error.localizedDescription)
            }
            
            
            
        }
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .itemSaveNotification, object: nil)
    }
    
    @objc func handleChooseImageButton() {
        self.selectPhotoFromLibrary()
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
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        coreData()
    }
    
    private func coreData() {
        if avengerID != 0 {
            let avengerFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Avengers")
            avengerFetch.fetchLimit = 1
            // condition with predicate
            avengerFetch.predicate = NSPredicate(format: "id == \(avengerID)")
            
            //run
            let result = try! context.fetch(avengerFetch)
            let avengers: Avengers = result.first as! Avengers
            //assign data
            firstNameTextField.text = avengers.firstName
            lastNameTextField.text = avengers.lastName
            emailTextField.text = avengers.email
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM YYYY"
            guard let birhtDate = avengers.birthDate else {
                return
            }
            guard let date = dateFormatter.date(from: birhtDate) else {
                return
            }
            datePicker.date = date
            guard let image = avengers.image else {
                return
            }
            previewImageview.image = UIImage(data: image)
        }
    }
    
    private func selectPhotoFromLibrary() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    

}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddTeamViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.previewImageview.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}

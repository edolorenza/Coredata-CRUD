//
//  DetailViewController.swift
//  CoreData-CRUD
//
//  Created by Edo Lorenza on 23/06/21.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    //MARK: - Properties
    
    var viewModel: MainViewTableViewCellViewModel? {
        didSet { configure() }
    }
    
    var avengerID = 0
    
    private let previewImageview: UIImageView =  {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        return iv
    }()
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let birthDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Birth Date"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let firstNameValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let lastNameValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let birthDateValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let emailValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        title = viewModel?.name
        navigationButton()
        setupView()
        
    }
    //MARK: - Actions
    @objc func editButtonTap() {
        let vc = AddTeamViewController()
        guard let id = viewModel?.id else {
            return
        }
        vc.navigationItem.title = "Edit Form"
        vc.avengerID = Int(id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configure()
    }
    
    @objc func deleteButtonTap() {
        let alertController = UIAlertController(title: "Warning", message: "Are you sure to delete this item ?", preferredStyle: .actionSheet)
        let alertAction  = UIAlertAction(title: "yes", style: .default) { action in
            let avengerFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Avengers")
            
            avengerFetch.fetchLimit = 1
            // condition with predicate
            avengerFetch.predicate = NSPredicate(format: "id == \(self.avengerID)")
            
            //run
            let result = try! self.context.fetch(avengerFetch)
            let avengersToDelete = result.first as! NSManagedObject
            
            self.context.delete(avengersToDelete)
            
            do {
                try self.context.save()
            }
            catch {
                print(error.localizedDescription)
            }
            
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: .itemSaveNotification, object: nil)
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        alertController.addAction(alertCancel)
        self.present(alertController, animated: true) {
            NotificationCenter.default.post(name: .itemSaveNotification, object: nil)
        }
    }
    
    
    //MARK: - Helpers
    private func navigationButton(){
        let editButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(editButtonTap))
        
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteButtonTap))
        
        self.navigationItem.rightBarButtonItems = [editButton,deleteButton]
    }
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        view.addSubview(previewImageview)
        previewImageview.centerX(inView: view.self)
        previewImageview.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        let imageSize = view.frame.width/2
        previewImageview.setDimensions(height: imageSize, width: imageSize)
        previewImageview.layer.cornerRadius = imageSize/2
        
        let stack = UIStackView(arrangedSubviews: [firstNameLabel, firstNameValueLabel, lastNameLabel, lastNameValueLabel, birthDateLabel, birthDateValueLabel, emailLabel, emailValueLabel])
        stack.axis = .vertical
        stack.spacing = 8
        
        view.addSubview(stack)
        stack.anchor(top: previewImageview.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 24, paddingRight: 24)
        
    }
    
    func configure() {
        previewImageview.image = viewModel?.image
        firstNameValueLabel.text = viewModel?.firstName
        lastNameValueLabel.text = viewModel?.lastName
        emailValueLabel.text = viewModel?.email
        birthDateValueLabel.text = viewModel?.date
    }

}

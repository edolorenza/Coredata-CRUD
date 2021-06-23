//
//  MainViewTableViewCell.swift
//  CoreData-CRUD
//
//  Created by Edo Lorenza on 23/06/21.
//

import UIKit

class MainViewTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "MainViewTableViewCell"
    
    var viewModel: MainViewTableViewCellViewModel? {
        didSet { configure() }
    }

    
    private let previewImageview: UIImageView =  {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let birthDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Helpers
    private func setupView(){
        self.backgroundColor = .systemBackground
        addSubview(previewImageview)
        previewImageview.centerY(inView: self)
        previewImageview.anchor(left: leftAnchor, paddingLeft: 8)
        
        previewImageview.setDimensions(height: 70, width: 70)
        previewImageview.layer.cornerRadius = 35
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, left: previewImageview.rightAnchor,paddingTop: 8, paddingLeft: 8)
        
        
        addSubview(birthDateLabel)
        birthDateLabel.anchor(top: nameLabel.bottomAnchor, left: previewImageview.rightAnchor, paddingTop: 4, paddingLeft: 8)
    }
    
    func configure() {
        nameLabel.text = viewModel?.name
        previewImageview.image = viewModel?.image
        birthDateLabel.text = viewModel?.date
    }
}

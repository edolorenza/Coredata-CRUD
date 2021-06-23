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
    }
}

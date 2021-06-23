//
//  NoDataView.swift
//  CoreData-CRUD
//
//  Created by Edo Lorenza on 23/06/21.
//

import UIKit

struct NoDataLabelViewViewModel {
    let text: String
    let actionTitle: String
}

protocol NoDataLabelViewDelegate: AnyObject {
    func noDataLabelViewDidTapButton(_ actionView: NoDataLabelView)
}
class NoDataLabelView: UIView {
    //MARK: - Properties
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        
        return button
    }()
    
    weak var delegate: NoDataLabelViewDelegate?
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    //MARK: - Actions
    @objc func didTapButton(){
        delegate?.noDataLabelViewDidTapButton(self)
    }
    
    //MARK: - Helpers
    private func setupView(){
        
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        
        addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.centerX(inView: label)
        button.anchor(top: label.bottomAnchor, paddingTop: 16)
    }
    
    func configure(with viewModel: NoDataLabelViewViewModel){
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
}

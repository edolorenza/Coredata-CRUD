//
//  ViewController.swift
//  CoreData-CRUD
//
//  Created by Edo Lorenza on 23/06/21.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: - Properties
    private let noDataList = NoDataLabelView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Employee"
        view.backgroundColor = .systemBackground
        setupView()
        
        noDataList.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(noDataList)
        noDataList.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noDataList.center = view.center
    }

    //MARK: - Helpers
    private func setupView(){
        noDataList.configure(with: NoDataLabelViewViewModel(
                            text: "You don't have any data yet",
                            actionTitle: "Add Data"))
        view.backgroundColor = .systemBackground
    }

}

//MARK: - NoDataLabelViewDelegate
extension MainViewController: NoDataLabelViewDelegate {
    func noDataLabelViewDidTapButton(_ actionView: NoDataLabelView) {
        print("DEBUG: add data button tapped")
    }
}

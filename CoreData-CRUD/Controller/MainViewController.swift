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
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.clipsToBounds = true
        tableView.register(MainViewTableViewCell.self, forCellReuseIdentifier: MainViewTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Avenger Team"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAddData))
        searchController.searchBar.placeholder = "Find Avenger's"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.searchController = searchController
        
        setupView()
        setupTableView()
        noDataList.delegate = self
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(noDataList)
        noDataList.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noDataList.center = view.center
    }

    //MARK: - Actions
    @objc func didTapAddData() {
        let vc = AddTeamViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - Helpers
    private func setupView(){
        noDataList.configure(with: NoDataLabelViewViewModel(
                            text: "You don't have any data yet",
                            actionTitle: "Add Data"))
        view.backgroundColor = .systemBackground
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }

}

//MARK: - NoDataLabelViewDelegate
extension MainViewController: NoDataLabelViewDelegate {
    func noDataLabelViewDidTapButton(_ actionView: NoDataLabelView) {
        print("DEBUG: add data button tapped")
    }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
}

//MARK: -
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainViewTableViewCell.identifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

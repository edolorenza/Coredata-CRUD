//
//  ViewController.swift
//  CoreData-CRUD
//
//  Created by Edo Lorenza on 23/06/21.
//

import UIKit
import CoreData

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
    
    var avengers: [Avengers] = []
    var filteredAvengers: [Avengers] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var observer: NSObjectProtocol?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Avenger Team"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAddData))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController!.navigationBar.sizeToFit()

        searchController.searchBar.placeholder = "Find Avenger's"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        setupView()
        setupTableView()
        noDataList.delegate = self
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        observer = NotificationCenter.default.addObserver(forName: .itemSaveNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateUI()
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(noDataList)
        noDataList.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noDataList.center = view.center
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let avengerFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Avengers")
            avengers = try context.fetch(avengerFetch) as! [Avengers]
        } catch  {
            print(error.localizedDescription)
        }
        self.updateUI()
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
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    private func updateUI(){
        if avengers.isEmpty {
            tableView.reloadData()
            searchController.searchBar.isHidden = true
            noDataList.isHidden = false
            tableView.isHidden = true
            
        }else {
            tableView.reloadData()
            searchController.searchBar.isHidden = false
            noDataList.isHidden = true
            tableView.isHidden = false
        }
    }
    
}

//MARK: - NoDataLabelViewDelegate
extension MainViewController: NoDataLabelViewDelegate {
    func noDataLabelViewDidTapButton(_ actionView: NoDataLabelView) {
        let vc = AddTeamViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let avenger = avengers[indexPath.row]
        let vc = DetailViewController()
        vc.viewModel = MainViewTableViewCellViewModel(avengers: avenger)
        vc.avengerID = Int(avenger.id)
        vc.navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && !((searchController.searchBar.text?.isEmpty)!) {
            return filteredAvengers.count
        }
        return avengers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainViewTableViewCell.identifier, for: indexPath) as? MainViewTableViewCell else {
            return UITableViewCell()
        }
        
        var avenger = avengers[indexPath.row]
        if searchController.isActive && !((searchController.searchBar.text?.isEmpty)!) {
             avenger = filteredAvengers[indexPath.row]
        }else{
             avenger = avengers[indexPath.row]
        }
        cell.viewModel = MainViewTableViewCellViewModel(avengers: avenger)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK: - UISearchControllerDelegate
extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let keyword = searchController.searchBar.text!
        if keyword.count > 0 {
            
            let avengerSearch = NSFetchRequest<NSFetchRequestResult>(entityName: "Avengers")
            let predicate1 = NSPredicate(format: "firstName CONTAINS[c] %@", keyword)
            let predicate2 = NSPredicate(format: "lastName CONTAINS[c] %@", keyword)
            
            let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates: [predicate1, predicate2])
            avengerSearch.predicate = predicateCompound
            
            //run query
            do {
                let avengerFilters = try context.fetch(avengerSearch) as! [NSManagedObject]
                filteredAvengers = avengerFilters as! [Avengers]
            }
            catch {
                print(error)
            }
            
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.updateUI()
    }
    
}



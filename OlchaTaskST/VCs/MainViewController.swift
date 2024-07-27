//
//  MainViewController.swift
//  OlchaTaskST
//
//  Created by Samandar on 25/07/24.
//


import UIKit

class MainViewController: UIViewController {
    
    var postData: [Post] = []
    var filteredData = [Post]()
    
    let tableView = UITableView()
    let searchbar = UISearchBar()
    let refreshController = UIRefreshControl()
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Main"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        gettingData()
        setupSearchbar()
        setupRefreshController()
        tableViewSetUp()
    }
    
    // MARK: Functions
    private func gettingData() {
        NetworkingC.shared.fetchPosts { [weak self] posts in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.postData = posts ?? []
                self.filteredData = self.postData
                self.tableView.reloadData()
                self.refreshController.endRefreshing()
            }
        }
    }
    
    private func setupSearchbar() {
        searchbar.delegate = self
        searchbar.showsCancelButton = true
        navigationItem.titleView = searchbar
    }
    
    private func setupRefreshController() {
        refreshController.addTarget(self, action: #selector(refreshInformation), for: .valueChanged)
        tableView.refreshControl = refreshController
    }
    
    private func tableViewSetUp() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OnlyTableViewCell.self, forCellReuseIdentifier: Cellname.OnlyTableViewCell.rawValue)
        view.addSubview(tableView)
    }
    
    
    //MARK: objc functions
    
    @objc func refreshInformation() {
        
        gettingData()
    }
   
}

// MARK: Extension for TableView
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cellname.OnlyTableViewCell.rawValue) as? OnlyTableViewCell else {
            return UITableViewCell(frame: UIScreen.main.bounds)
        }
        
        let postFilteredData = filteredData[indexPath.row]
        cell.gettingInformation(name: "Loading...", title: postFilteredData.title ?? "title")
        
        NetworkingC.shared.fetchUser(userId: postFilteredData.id ?? 0) { [weak cell] user in
            DispatchQueue.main.async {
                guard let cell = cell else { return }
                let username = user?.name ?? "no name"
                print(username)
                cell.gettingInformation(name: username, title: postFilteredData.title ?? "title")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = filteredData[indexPath.row]
        
        NetworkingC.shared.fetchUser(userId: post.id ?? 1) { [weak self] user in
            guard let self = self else {return}
            let fetchedUser = user ?? User(name: "After fetching error")
            
            DispatchQueue.main.async {
                let detailsVC = PostDetailsViewController(user: fetchedUser, post: post)
                let nc = UINavigationController(rootViewController: detailsVC)
                self.present(nc, animated: true, completion: nil)
            }
        }
    }
}

// MARK: Extension for SearchController
extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? postData : postData.filter { post in
            guard let title = post.title else { return false }
            return title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredData = postData
        tableView.reloadData()
    }
}

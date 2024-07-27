//
//  SavedsViewController.swift
//  OlchaTaskST
//
//  Created by Samandar on 25/07/24.
//

import UIKit
import CoreData

class SavedsViewController: UIViewController {
    
    
    let mcontext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView = UITableView()
    
    var postCDs: [PostCD]? = []
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Saved"
        navigationController?.navigationBar.prefersLargeTitles = true

        
        fetchingDataFromCoreData()
        tableViewSetUp()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchingDataFromCoreData()
        tableView.reloadData()
    }
    
    
    
    //MARK: Functions
    
    private func fetchingDataFromCoreData() {
        
        do {
            postCDs = try mcontext.fetch(PostCD.fetchRequest())
        }catch {
            print("Error: \(error), Error of fetching from Corte Data")
        }
        
        
    }
    
    
    private func tableViewSetUp() {
        
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OnlyTableViewCell.self, forCellReuseIdentifier: Cellname.OnlyTableViewCell.rawValue)
        view.addSubview(tableView)
    }
    
    
   
    
}







//MARK: For tableView extension

extension SavedsViewController: UITableViewDataSource, UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postCDs?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cellname.OnlyTableViewCell.rawValue) as? OnlyTableViewCell
        
        guard let cell else {
            return UITableViewCell(frame: UIScreen.main.bounds)
        }
        let postCD = postCDs?[indexPath.row]
        
        cell.gettingInformation(name: String(indexPath.row) + ". " + (postCD?.name ?? "AuthorName: No User"), title: postCD?.title ?? "Title: S Wick")
        return cell
    }

    // UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Deleting from Core Data
                guard let postToDelete = postCDs?[indexPath.row] else { return  }
                mcontext.delete(postToDelete)
                do {
                    try mcontext.save()
                    // Removing from the data source
                    postCDs?.remove(at: indexPath.row)
                    // Removing from the table view
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } catch {
                    print("Error: \(error), Could not delete item")
                }
            }
        }
    
}


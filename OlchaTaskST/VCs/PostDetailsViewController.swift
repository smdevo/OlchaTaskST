//
//  ViewController.swift
//  OlchaTaskST
//
//  Created by Samandar on 26/07/24.
//


import UIKit
import CoreData

class PostDetailsViewController: UIViewController {
    
    
    let mcontext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let user: User
    let post: Post
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    init(user: User, post: Post) {
        self.user = user
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = user.name ?? "UserName"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupNavigationBar()
        setupScrollView()
        setupStackView()
        setupUserDetails()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveContent))
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func setupUserDetails() {
        addLabel(withText: "ID: \(user.id ?? 1)")
        addLabel(withText: "Name: \(user.name ?? "name")")
        addLabel(withText: "Username: \(user.username ?? "username")")
        addLabel(withText: "Email: \(user.email ?? "email")")
        addLabel(withText: "Address: \(user.address?.street ?? "Street"), \(user.address?.suite ?? "suite"), \(user.address?.city ?? "city"), \(user.address?.zipcode ?? "zipCode")")
        addLabel(withText: "Phone: \(user.phone ?? "phone")")
        addLabel(withText: "Website: \(user.website ?? "website")")
        addLabel(withText: "Company: \(user.company?.name ?? "companyName"), \(user.company?.catchPhrase ?? "catchphrase"), \(user.company?.bs ?? "bs")")
        addLabel(withText: "Post", bold: true)
        addLabel(withText: "Title: \(post.title ?? "Title")")
        addLabel(withText: "Body: \(post.body ?? "Body")")
    }
    
    private func addLabel(withText text: String,bold: Bool = false) {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: label.font.pointSize, weight: bold ? .bold : .regular)
        stackView.addArrangedSubview(label)
    }
   
    
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveContent() {
        
        //Saving content
        
      let postCD = PostCD(context: mcontext)
        postCD.name = user.name
        
        postCD.id = Int64(post.id ?? 1)
        postCD.userId = Int64(post.userId ?? 1)
        postCD.title = post.title
        postCD.body = post.body
        
        do {
            try mcontext.save()
            print("Saved content")
        }catch {
            print("Error \(error), Can't be Saved")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

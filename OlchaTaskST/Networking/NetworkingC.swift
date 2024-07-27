//
//  NetworkingC.swift
//  OlchaTaskST
//
//  Created by Samandar on 26/07/24.
//


import Foundation

final class NetworkingC {
    
    static let shared: NetworkingC = NetworkingC()
    
    private var baseUrlStr = "https://jsonplaceholder.typicode.com/"
    private var postsEndpoint = "posts/"
    private var usersEndpoint = "users/"
    
    private init() {}
    
    func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        guard let postsURL = URL(string: baseUrlStr + postsEndpoint) else {
            print("Invalid posts URL")
            completion(nil)
            return
        }
        
        let session = URLSession.shared
        
        let postsTask = session.dataTask(with: postsURL) { data, response, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data received for posts")
                completion(nil)
                return
            }
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                print("Posts fetched successfully")
                completion(posts)
            } catch {
                print("Error decoding posts: \(error)")
                completion(nil)
            }
        }
        
        postsTask.resume()
    }
    
    func fetchUser(userId: Int, completion: @escaping (User?) -> Void) {
        guard let usersURL = URL(string: baseUrlStr + usersEndpoint + String(userId)) else {
            print("Invalid user URL")
            completion(nil)
            return
        }
        
        let session = URLSession.shared
        
        let usersTask = session.dataTask(with: usersURL) { data, response, error in
            if let error = error {
                print("Error fetching user: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data received for user")
                completion(nil)
                return
            }
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                print("User fetched successfully, \(user.name ?? "actual name")")
                completion(user)
            } catch {
                print("Error decoding users: \(error)")
                completion(nil)
            }
        }
        
        usersTask.resume()
    }
}

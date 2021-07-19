//
//  PostListVC.swift
//  kumparantest2021
//
//  Created by Ivan Martin on 19/07/2021.
//

import UIKit

class PostListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dispatchGroup = DispatchGroup()
    private let refreshControl = UIRefreshControl()
    var loadingObj : SpinnerViewController? = nil

    var posts: [Post] = []
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts"
        setupRefreshControl()
        setupTable()
        requestAPI()
    }
    
    func setupRefreshControl(){
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
    }
    
    func showLoading() {
        guard loadingObj == nil else { return }
        loadingObj = SpinnerViewController()

        // add the spinner view controller
        addChild(loadingObj!)
        loadingObj!.view.frame = view.frame
        view.addSubview(loadingObj!.view)
        loadingObj!.didMove(toParent: self)
    }
    
    func hideLoading(){
        guard loadingObj != nil else { return }
        loadingObj!.willMove(toParent: nil)
        loadingObj!.view.removeFromSuperview()
        loadingObj!.removeFromParent()
        loadingObj = nil
    }
    
    func setupTable() {
        self.tableView.register(UINib.init(nibName: "PostListCell", bundle: .main), forCellReuseIdentifier: "PostListCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 120
        self.tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.requestAPI()
    }
    
    func requestAPI(){
        showLoading()
        getPosts()
        getUsers()
        dispatchGroup.notify(queue: .main) {
            self.hideLoading()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func getPosts(){
        dispatchGroup.enter()
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                print(json)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let model = try decoder.decode([Post].self, from: data ?? Data())
                self.posts = model
            } catch {
                print("error",error)
            }
            self.dispatchGroup.leave()
        })

        task.resume()
    }
    
    func getUsers(){
        dispatchGroup.enter()
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/users")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                print(json)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let model = try decoder.decode([User].self, from: data ?? Data())
                self.users = model
            } catch {
                print("error",error)
            }
            self.dispatchGroup.leave()
        })

        task.resume()
    }

}

extension PostListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostListCell") as! PostListCell
        let found = users.first(where: {$0.id == self.posts[indexPath.row].userId})
        cell.nameLabel.text = found?.name
        cell.companyLabel.text = found?.company.name
        cell.titleLabel.text = self.posts[indexPath.row].title
        cell.bodyLabel.text = self.posts[indexPath.row].body
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = users.first(where: {$0.id == self.posts[indexPath.row].userId}){
            let vc = PostDetailVC(nibName: "PostDetailVC", bundle: nil)
            vc.post = posts[indexPath.row]
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

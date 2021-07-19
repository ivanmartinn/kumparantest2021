//
//  PostDetailVC.swift
//  kumparantest2021
//
//  Created by Ivan Martin on 19/07/2021.
//

import UIKit

class PostDetailVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    var loadingObj : SpinnerViewController? = nil
    
    var post: Post!
    var user: User!
    var comments: [Comment] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
        getComment()
    }
    
    func setupUI(){
        self.title = "Detail"
        self.nameLabel.text = user.name
        self.titleLabel.text = post.title
        self.bodyLabel.text = post.body
        self.scrollView.refreshControl = refreshControl
        self.nameLabel.isUserInteractionEnabled = true
        self.nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nameTapped(_:))))
    }
    
    func setupTable() {
        self.tableView.register(UINib.init(nibName: "PostDetailCell", bundle: .main), forCellReuseIdentifier: "PostDetailCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 50
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
        DispatchQueue.main.async {
            self.loadingObj!.willMove(toParent: nil)
            self.loadingObj!.view.removeFromSuperview()
            self.loadingObj!.removeFromParent()
            self.loadingObj = nil
        }
    }
    
    @objc private func nameTapped(_ sender: Any) {
        let vc = UserDetailVC(nibName: "UserDetailVC", bundle: nil)
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func refreshData(_ sender: Any) {
        getComment()
    }

    func getComment(){
        showLoading()
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(post.id)")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                print(json)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let model = try decoder.decode([Comment].self, from: data ?? Data())
                self.comments = model + model
            } catch {
                print("error",error)
            }
            self.hideLoading()
        })
        
        task.resume()
    }

}

extension PostDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailCell") as! PostDetailCell
        let name = comments[indexPath.row].name
        let fullComment = name + comments[indexPath.row].body
        let nameRange = (name as NSString).range(of: fullComment)
        let attributedString = NSMutableAttributedString(string: fullComment)
        attributedString.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], range: NSMakeRange(0, attributedString.length))
        attributedString.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)], range: nameRange)
        cell.commentLabel.attributedText = attributedString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
